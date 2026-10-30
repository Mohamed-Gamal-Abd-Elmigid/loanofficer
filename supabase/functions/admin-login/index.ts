import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "npm:@supabase/supabase-js@2";
import { withSupabase } from "jsr:@supabase/server@^1";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

export default {
  fetch: withSupabase({ auth: ["publishable", "secret"] }, async (req, ctx) => {
    if (req.method === "OPTIONS") {
      return new Response("ok", { headers: corsHeaders });
    }

    try {
      const body = await req.json();
      const phone = String(body.phone ?? "").trim();
      const password = String(body.password ?? "");
      if (!phone || !password) {
        return json({ error: "رقم المسؤول وكلمة المرور مطلوبان" }, 400);
      }

      const admin = adminClient(ctx);
      const { data: account, error: lookupError } = await admin
        .from("admins")
        .select("email")
        .eq("phone", phone)
        .maybeSingle();

      if (lookupError || !account?.email) {
        return json({ error: "بيانات الدخول غير صحيحة" }, 401);
      }

      const auth = createClient(supabaseUrl(), clientKey(), {
        auth: { persistSession: false, autoRefreshToken: false },
      });
      const { data, error } = await auth.auth.signInWithPassword({
        email: account.email,
        password,
      });

      if (error || !data.session) {
        return json({ error: "بيانات الدخول غير صحيحة" }, 401);
      }

      return json({
        access_token: data.session.access_token,
        refresh_token: data.session.refresh_token,
        expires_in: data.session.expires_in,
      });
    } catch {
      return json({ error: "تعذر تسجيل الدخول" }, 500);
    }
  }),
};

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
