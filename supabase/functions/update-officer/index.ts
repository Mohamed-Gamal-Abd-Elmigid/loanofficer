import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "npm:@supabase/supabase-js@2";
import { withSupabase } from "jsr:@supabase/server@^1";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const emailPattern = /^[a-z0-9._%+\-]+@tanmeyah\.com$/;

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
      const employeeId = String(body.employee_id ?? "").trim();
      const email = String(body.email ?? "").trim().toLowerCase();
      const fullName = String(body.full_name ?? "").trim();
      const password = String(body.password ?? "");

      if (!id || !employeeId || !email || !fullName) {
        return json({ error: "كل الحقول مطلوبة" }, 400);
      }
      if (!emailPattern.test(email)) {
        return json({ error: "الايميل غير صحيح" }, 400);
      }
      if (password && !isStrongPassword(password)) {
        return json({ error: "كلمة المرور ضعيفة" }, 400);
      }

      const { data: officer } = await admin
        .from("officers")
        .select("id")
        .eq("id", id)
        .maybeSingle();
      if (!officer) return json({ error: "المستخدم غير موجود" }, 404);

      const { data: sameEmployee } = await admin
        .from("officers")
        .select("id")
        .eq("employee_id", employeeId)
        .neq("id", id)
        .maybeSingle();
      if (sameEmployee) return json({ error: "رقم الموظف مستخدم بالفعل" }, 409);

      const { data: sameEmail } = await admin
        .from("officers")
        .select("id")
        .eq("email", email)
        .neq("id", id)
        .maybeSingle();
      if (sameEmail) return json({ error: "هذا الايميل مسجل بالفعل" }, 409);

      const attributes: {
        email: string;
        email_confirm: boolean;
        user_metadata: { employee_id: string; full_name: string };
        password?: string;
      } = {
        email,
        email_confirm: true,
        user_metadata: {
          employee_id: employeeId,
          full_name: fullName,
        },
      };
      if (password) attributes.password = password;

      const { error: authError } = await admin.auth.admin.updateUserById(id, attributes);
      if (authError) {
        const message = authError.message.toLowerCase();
        if (message.includes("already") || message.includes("registered")) {
          return json({ error: "هذا الايميل مسجل بالفعل" }, 409);
        }
        return json({ error: "تعذر تحديث المستخدم" }, 400);
      }

      const { error: rowError } = await admin
        .from("officers")
        .update({
          employee_id: employeeId,
          email,
          full_name: fullName,
        })
        .eq("id", id);
      if (rowError) return json({ error: "تعذر تحديث المستخدم" }, 400);

      return json({ ok: true });
    } catch {
      return json({ error: "تعذر تحديث المستخدم" }, 500);
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
