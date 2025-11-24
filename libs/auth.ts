import jwt, { SignOptions } from "jsonwebtoken";
import { NextRequest } from "next/server";

// JWT Configuration
const JWT_SECRET = process.env.JWT_SECRET || "your-secret-key-change-this-in-production";
const JWT_EXPIRES_IN = process.env.JWT_EXPIRES_IN || "7d";

export interface JWTPayload {
  userId: string;
  email: string;
  role: string;
}

/**
 * Generates a JWT token for a user
 */
export function generateToken(payload: JWTPayload): string {
  const options: SignOptions = {
    expiresIn: parseInt(JWT_EXPIRES_IN),
  };

  return jwt.sign(payload, JWT_SECRET, options);
}

/**
 * Verifies and decodes a JWT token
 */
export function verifyToken(token: string): JWTPayload | null {
  try {
    const decoded = jwt.verify(token, JWT_SECRET) as JWTPayload;
    return decoded;
  } catch (error) {
    return null;
  }
}

/**
 * Extracts JWT token from request headers or cookies
 */
export function getTokenFromRequest(request: NextRequest): string | null {
  // Try to get from Authorization header
  const authHeader = request.headers.get("authorization");
  if (authHeader && authHeader.startsWith("Bearer ")) {
    return authHeader.substring(7);
  }

  // Try to get from cookies
  const token = request.cookies.get("token")?.value;
  if (token) {
    return token;
  }

  return null;
}

/**
 * Extracts user from request by verifying JWT token
 */
export function getUserFromRequest(request: NextRequest): JWTPayload | null {
  const token = getTokenFromRequest(request);
  if (!token) {
    return null;
  }

  return verifyToken(token);
}
