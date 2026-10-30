create table public.password_reset_codes (
  officer_id uuid primary key references public.officers (id) on delete cascade,
  code_hash text not null,
  recovery_token text not null,
  expires_at timestamptz not null,
  created_at timestamptz not null default now()
);

alter table public.password_reset_codes enable row level security;

revoke all on table public.password_reset_codes from anon, authenticated;
