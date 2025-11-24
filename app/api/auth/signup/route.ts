import { NextRequest, NextResponse } from "next/server";
import { db } from "@/libs/db";
import bcrypt from "bcrypt";
import { z } from "zod";
import crypto from "crypto";

// Validation schema
const signupSchema = z.object({
  email: z.string().min(1, "Email is required").email({ message: "Invalid email address" }),
  password: z
    .string()
    .min(8, "Password must be at least 8 characters")
    .regex(
      /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/,
      "Password must contain at least one uppercase letter, one lowercase letter, and one number"
    ),
  first_name: z.string().min(1, "First name is required"),
  last_name: z.string().min(1, "Last name is required"),
  phone: z.string().optional(),
  role: z.enum(["client_individual", "client_corporate", "guest"]).default("guest"),

  // Optional corporate fields
  company_name: z.string().optional(),
  industry: z.string().optional(),
  company_size: z.string().optional(),
  job_title: z.string().optional(),
  department: z.string().optional(),

  // Optional individual fields
  profession: z.string().optional(),
  linkedin_url: z.string().url({ message: "Invalid URL format" }).optional().or(z.literal("")),

  // Preferences
  communication_preference: z.string().optional(),
  timezone: z.string().optional(),
  language_preference: z.string().default("en"),
});

type SignupData = z.infer<typeof signupSchema>;

export async function POST(request: NextRequest) {
  try {
    // Parse request body
    const body = await request.json();

    // Validate input
    const validationResult = signupSchema.safeParse(body);

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

    const data: SignupData = validationResult.data;

    // Check if user already exists
    const existingUser = await db.user.findUnique({
      where: { email: data.email },
    });

    if (existingUser) {
      return NextResponse.json(
        { error: "User with this email already exists" },
        { status: 409 }
      );
    }

    // Hash password
    const saltRounds = 10;
    const password_hash = await bcrypt.hash(data.password, saltRounds);

    // Generate email verification token
    const email_verification_token = crypto.randomBytes(32).toString("hex");

    // Create user
    const user = await db.user.create({
      data: {
        email: data.email,
        password_hash,
        first_name: data.first_name,
        last_name: data.last_name,
        phone: data.phone,
        role: data.role,

        // Corporate fields
        company_name: data.company_name,
        industry: data.industry,
        company_size: data.company_size,
        job_title: data.job_title,
        department: data.department,

        // Individual fields
        profession: data.profession,
        linkedin_url: data.linkedin_url,

        // Preferences
        communication_preference: data.communication_preference,
        timezone: data.timezone,
        language_preference: data.language_preference,

        // Verification
        email_verified: false,
        email_verification_token,
      },
      select: {
        id: true,
        email: true,
        first_name: true,
        last_name: true,
        role: true,
        created_at: true,
        email_verified: true,
      },
    });

    // TODO: Send verification email
    // You can integrate with a service like SendGrid, Resend, or AWS SES
    // Example:
    // await sendVerificationEmail(user.email, email_verification_token);

    return NextResponse.json(
      {
        message: "User created successfully. Please check your email to verify your account.",
        user,
        // Include verification token in development only
        ...(process.env.NODE_ENV === "development" && {
          verification_token: email_verification_token,
        }),
      },
      { status: 201 }
    );
  } catch (error) {
    console.error("Signup error:", error);

    // Handle Prisma errors
    if (error instanceof Error) {
      if (error.message.includes("Unique constraint")) {
        return NextResponse.json(
          { error: "User with this email already exists" },
          { status: 409 }
        );
      }
    }

    return NextResponse.json(
      { error: "Internal server error. Please try again later." },
      { status: 500 }
    );
  }
}
