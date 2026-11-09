import { connection } from "next/server";
import { supabaseEnv } from "@/lib/supabase/env";

/** GET /api/health: reports whether the app can reach Supabase with its publishable key. */
export async function GET() {
  await connection(); // always check live, never serve a prerendered answer
  try {
    const { url, key } = supabaseEnv();
    const res = await fetch(`${url}/auth/v1/health`, { headers: { apikey: key }, cache: "no-store" });
    const ok = res.ok;
    return Response.json({ supabase: ok ? "ok" : `error ${res.status}` }, { status: ok ? 200 : 503 });
  } catch (error) {
    const message = error instanceof Error ? error.message : "unknown error";
    return Response.json({ supabase: "error", message }, { status: 503 });
  }
}
