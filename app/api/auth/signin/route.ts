import { NextRequest, NextResponse } from "next/server";
import { db } from "@/libs/db";
import bcrypt from "bcrypt";
import { z } from "zod";
import { generateToken } from "@/libs/auth";

// Validation schema
const signinSchema = z.object({
  email: z.string().min(1, "Email is required").email({ message: "Invalid email address" }),
  password: z.string().min(1, "Password is required"),
});

type SigninData = z.infer<typeof signinSchema>;

export async function POST(request: NextRequest) {
  try {
    // Parse request body
    const body = await request.json();

    // Validate input
    const validationResult = signinSchema.safeParse(body);

    if (!validationResult.success) {
      return NextResponse.json(
        {
          error: "Validation failed",
          details: validationResult.error.issues.map((err) => ({
            field: err.path.join("."),
            message: err.message,
          })),
        },
        { status: 400 }
      );
    }

    const data: SigninData = validationResult.data;

    // Find user by email
    const user = await db.user.findUnique({
      where: { email: data.email },
      select: {
        id: true,
        email: true,
        password_hash: true,
        first_name: true,
        last_name: true,
        role: true,
        email_verified: true,
        profile_picture_url: true,
      },
    });

    if (!user) {
      return NextResponse.json(
        { error: "Invalid email or password" },
        { status: 401 }
      );
    }

    // Check if user has a password (some users might be OAuth only)
    if (!user.password_hash) {
      return NextResponse.json(
        { error: "Please sign in using your social account" },
        { status: 401 }
      );
    }

    // Verify password
    const isPasswordValid = await bcrypt.compare(data.password, user.password_hash);

    if (!isPasswordValid) {
      return NextResponse.json(
        { error: "Invalid email or password" },
        { status: 401 }
      );
    }

    // Check if email is verified (optional - you can remove this if not required)
    // if (!user.email_verified) {
    //   return NextResponse.json(
    //     {
    //       error: "Email not verified",
    //       message: "Please verify your email address before signing in",
    //     },
    //     { status: 403 }
    //   );
    // }

    // Update last login
    await db.user.update({
      where: { id: user.id },
      data: { last_login: new Date() },
    });

    // Generate JWT token
    const token = generateToken({
      userId: user.id,
      email: user.email,
      role: user.role,
    });

    // Prepare user data (without password hash)
    const userData = {
      id: user.id,
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name,
      role: user.role,
      profile_picture_url: user.profile_picture_url,
    };

    // Create response with token in cookie
    const response = NextResponse.json(
      {
        message: "Sign in successful",
        user: userData,
        token, // Also include in response body for flexibility
      },
      { status: 200 }
    );

    // Set HTTP-only cookie with token for enhanced security
    response.cookies.set("token", token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === "production",
      sameSite: "lax",
      maxAge: 60 * 60 * 24 * 7, // 7 days
      path: "/",
    });

    return response;
  } catch (error) {
    console.error("Signin error:", error);

    return NextResponse.json(
      { error: "Internal server error. Please try again later." },
      { status: 500 }
    );
  }
}