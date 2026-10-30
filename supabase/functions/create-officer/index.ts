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
      const employeeId = String(body.employee_id ?? "").trim();
      const email = String(body.email ?? "").trim().toLowerCase();
      const fullName = String(body.full_name ?? "").trim();
      const password = String(body.password ?? "");

      if (!employeeId || !email || !fullName || !password) {
        return json({ error: "كل الحقول مطلوبة" }, 400);
      }
      if (!email.includes("@") || !email.includes(".")) {
        return json({ error: "الايميل غير صحيح" }, 400);
      }
      if (!isStrongPassword(password)) {
        return json({ error: "كلمة المرور ضعيفة" }, 400);
      }

      const { data: existing } = await admin
        .from("officers")
        .select("id")
        .eq("employee_id", employeeId)
        .maybeSingle();
      if (existing) return json({ error: "رقم الموظف مستخدم بالفعل" }, 409);

      const { error } = await admin.auth.admin.createUser({
        email,
        password,
        email_confirm: true,
        user_metadata: {
          employee_id: employeeId,
          full_name: fullName,
        },
      });

      if (error) {
        const message = error.message.toLowerCase();
        if (message.includes("already") || message.includes("registered")) {
          return json({ error: "هذا الايميل مسجل بالفعل" }, 409);
        }
        return json({ error: "تعذر إنشاء المستخدم" }, 400);
      }

      return json({ ok: true });
    } catch {
      return json({ error: "تعذر إنشاء المستخدم" }, 500);
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

function isStrongPassword(password: string) {
  return password.length >= 8 &&
    /[A-Z]/.test(password) &&
    /[a-z]/.test(password) &&
    /[0-9]/.test(password) &&
    /[!@#$%&*]/.test(password);
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
