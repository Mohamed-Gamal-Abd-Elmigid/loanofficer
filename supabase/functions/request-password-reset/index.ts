import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "npm:@supabase/supabase-js@2";
import { withSupabase } from "jsr:@supabase/server@^1";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const pinLength = 5;
const pinLifetimeMs = 60 * 60 * 1000;

export default {
  fetch: withSupabase({ auth: ["publishable", "secret"] }, async (req, ctx) => {
    if (req.method === "OPTIONS") {
      return new Response("ok", { headers: corsHeaders });
    }

    try {
      const body = await req.json();
      const employeeId = String(body.employee_id ?? "").trim();
      const email = String(body.email ?? "").trim().toLowerCase();
      const code = String(body.code ?? "").trim();
      if (!employeeId || !email) {
        return json({ error: "Email and employee number are required" }, 400);
      }

      const admin = adminClient(ctx);
      const { data: officer, error: lookupError } = await admin
        .from("officers")
        .select("id")
        .eq("employee_id", employeeId)
        .eq("email", email)
        .maybeSingle();

      if (lookupError || !officer) {
        return json({ error: "No account matches these details" }, 404);
      }

      if (code) return await verifyPin(admin, officer.id, email, code);
      return await issuePin(admin, officer.id, email);
    } catch {
      return json({ error: "Could not send the code" }, 500);
    }
  }),
};

async function issuePin(
  admin: ReturnType<typeof createClient>,
  officerId: string,
  email: string,
) {
  const { data, error } = await admin.auth.admin.generateLink({
    type: "recovery",
    email,
  });
  const recoveryToken = data?.properties?.email_otp;
  if (error || !recoveryToken) {
    return json({ error: "Could not send the code" }, 400);
  }

  const pin = fiveDigitPin();
  const { error: saveError } = await admin.from("password_reset_codes").upsert({
    officer_id: officerId,
    code_hash: await sha256(pin),
    recovery_token: recoveryToken,
    expires_at: new Date(Date.now() + pinLifetimeMs).toISOString(),
  });
  if (saveError) return json({ error: "Could not send the code" }, 500);

  // Shown in the app until an SMS gateway sends the code instead.
  return json({ ok: true, otp: pin });
}

async function verifyPin(
  admin: ReturnType<typeof createClient>,
  officerId: string,
  email: string,
  code: string,
) {
  if (!new RegExp(`^\\d{${pinLength}}$`).test(code)) {
    return json({ error: "The code is incorrect or expired" }, 400);
  }

  const { data: row, error } = await admin
    .from("password_reset_codes")
    .select("code_hash, recovery_token, expires_at")
    .eq("officer_id", officerId)
    .maybeSingle();

  const expired = !row || Date.parse(row.expires_at) <= Date.now();
  const hash = await sha256(code);
  if (error || expired || hash !== row?.code_hash) {
    return json({ error: "The code is incorrect or expired" }, 400);
  }

  const auth = createClient(supabaseUrl(), clientKey(), {
    auth: { persistSession: false, autoRefreshToken: false },
  });
  const { data, error: verifyError } = await auth.auth.verifyOtp({
    email,
    token: row.recovery_token,
    type: "recovery",
  });
  if (verifyError || !data.session) {
    return json({ error: "The code is incorrect or expired" }, 400);
  }

  await admin.from("password_reset_codes").delete().eq("officer_id", officerId);

  return json({
    access_token: data.session.access_token,
    refresh_token: data.session.refresh_token,
  });
}

function fiveDigitPin() {
  const bytes = new Uint32Array(1);
  crypto.getRandomValues(bytes);
  return String(bytes[0] % 100000).padStart(pinLength, "0");
}

async function sha256(value: string) {
  const digest = await crypto.subtle.digest(
    "SHA-256",
    new TextEncoder().encode(value),
  );
  return [...new Uint8Array(digest)]
    .map((byte) => byte.toString(16).padStart(2, "0"))
    .join("");
}

function adminClient(ctx: { supabaseAdmin?: ReturnType<typeof createClient> }) {
  if (ctx.supabaseAdmin) return ctx.supabaseAdmin;
  return createClient(supabaseUrl(), serviceKey(), {
    auth: { persistSession: false, autoRefreshToken: false },
  });
}

function supabaseUrl() {
  const url = Deno.env.get("SUPABASE_URL");
  if (!url) throw new Error("SUPABASE_URL is missing");
  return url;
}

function serviceKey() {
  const key = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ??
    Deno.env.get("SUPABASE_SECRET_KEY");
  if (!key) throw new Error("service key is missing");
  return key;
}

function clientKey() {
  return Deno.env.get("SUPABASE_ANON_KEY") ??
    "sb_publishable_My5qYKip0m-v_uQsbGawQg_e62YbxwJ";
}

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json; charset=utf-8" },
  });
}
