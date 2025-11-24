import { NextRequest, NextResponse } from "next/server";
import { getUserFromRequest } from "@/libs/auth";

export async function POST(request: NextRequest) {
  try {
    // Optional: Verify user is authenticated before signing out
    const user = getUserFromRequest(request);

    // Create response
    const response = NextResponse.json(
      {
        message: "Sign out successful",
      },
      { status: 200 }
    );

    // Clear the authentication cookie
    response.cookies.set("token", "", {
      httpOnly: true,
      secure: process.env.NODE_ENV === "production",
      sameSite: "lax",
      maxAge: 0, // Expire immediately
      path: "/",
    });

    return response;
  } catch (error) {
    console.error("Signout error:", error);

    // Even if there's an error, we should still clear the cookie
    const response = NextResponse.json(
      { error: "An error occurred during sign out" },
      { status: 500 }
    );

    response.cookies.set("token", "", {
      httpOnly: true,
      secure: process.env.NODE_ENV === "production",
      sameSite: "lax",
      maxAge: 0,
      path: "/",
    });

    return response;
  }
}

// Also support GET request for easier signout links
export async function GET(request: NextRequest) {
  return POST(request);
}
