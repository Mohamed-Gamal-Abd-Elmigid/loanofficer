create table public.admins (
  id uuid primary key references auth.users (id) on delete cascade,
  phone text not null,
  email text not null,
  full_name text,
  created_at timestamptz not null default now(),
  constraint admins_phone_key unique (phone),
  constraint admins_email_key unique (email)
);

alter table public.admins enable row level security;

create policy "admins_select_own"
  on public.admins
  for select
  to authenticated
  using ((select auth.uid()) = id);

grant select on table public.admins to authenticated;

create policy "admins_select_officers"
  on public.officers
  for select
  to authenticated
  using (
    exists (
      select 1
      from public.admins
      where admins.id = (select auth.uid())
    )
  );

create or replace function public.handle_new_admin()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if coalesce(new.raw_user_meta_data ->> 'role', '') <> 'admin' then
    return new;
  end if;

  if new.raw_user_meta_data ->> 'phone' is null then
    raise exception 'admin phone is required';
  end if;

  insert into public.admins (id, phone, email, full_name)
  values (
    new.id,
    new.raw_user_meta_data ->> 'phone',
    lower(new.email),
    new.raw_user_meta_data ->> 'full_name'
  )
  on conflict (id) do update
    set phone = excluded.phone,
        email = excluded.email,
        full_name = excluded.full_name;

  return new;
end;
$$;

create trigger on_auth_admin_created
  after insert on auth.users
  for each row
  execute function public.handle_new_admin();
