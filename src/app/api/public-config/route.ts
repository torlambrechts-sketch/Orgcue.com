import { connection } from "next/server";
import { supabaseEnv } from "@/lib/supabase/env";

/**
 * GET /api/public-config: the public Supabase settings the static page needs for optional sign-in.
 * Both values are public (the URL and the publishable key), so the page never has to hard-code them.
 */
export async function GET() {
  await connection(); // read the environment at request time, never serve a prerendered answer
  try {
    const { url, key } = supabaseEnv();
    return Response.json({ url, key }, { headers: { "Cache-Control": "no-store" } });
  } catch {
    return Response.json({ error: "Sign-in is not configured on this server." }, { status: 503 });
  }
}
