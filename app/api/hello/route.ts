import { NextRequest, NextResponse } from "next/server";
import { db } from "@/libs/db";

export async function GET(): Promise<NextResponse<{ message: string; status: string; }>> {
    try {
        await db.$connect();
        console.log("Db is connected");

        return NextResponse.json({
            message: "Hello from the API!",
            status: "success"
        });
    } catch (error) {
        console.error("Database connection error:", error);
        return NextResponse.json({
            message: "Database connection failed",
            status: "error"
        }, { status: 500 });
    }
}