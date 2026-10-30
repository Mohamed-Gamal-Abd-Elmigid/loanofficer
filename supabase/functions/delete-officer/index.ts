import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "npm:@supabase/supabase-js@2";
import { withSupabase } from "jsr:@supabase/server@^1";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

export default {
  fetch: withSupabase({ auth: ["user", "publishable", "secret"] }, async (req, ctx) => {
    if (req.method === "OPTIONS") {
      return new Response("ok", { headers: corsHeaders });
    }

    try {
      const caller = await callerId(req);
      if (!caller) return json({ error: "غير مصرح" }, 401);

      const admin = adminClient(ctx);
      const { data: account } = await admin
        .from("admins")
        .select("id")
        .eq("id", caller)
        .maybeSingle();
      if (!account) return json({ error: "غير مصرح" }, 403);

      const body = await req.json();
      const id = String(body.id ?? "").trim();
      if (!id) return json({ error: "المستخدم غير محدد" }, 400);

      const { data: officer } = await admin
        .from("officers")
        .select("id")
        .eq("id", id)
        .maybeSingle();
      if (!officer) return json({ error: "المستخدم غير موجود" }, 404);

      const { error } = await admin.auth.admin.deleteUser(id);
      if (error) return json({ error: "تعذر حذف المستخدم" }, 400);

      await admin.from("officers").delete().eq("id", id);
      return json({ ok: true });
    } catch {
      return json({ error: "تعذر حذف المستخدم" }, 500);
    }
  }),
};

async function callerId(req: Request) {
  const header = req.headers.get("Authorization") ?? "";
  const token = header.replace(/^Bearer\s+/i, "");
  if (!token || token.startsWith("sb_publishable_")) return null;
  const auth = createClient(supabaseUrl(), clientKey(), {
    global: { headers: { Authorization: `Bearer ${token}` } },
    auth: { persistSession: false, autoRefreshToken: false },
  });
  const { data } = await auth.auth.getUser(token);
  return data.user?.id ?? null;
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
