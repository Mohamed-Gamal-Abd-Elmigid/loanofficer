create table public.officers (
  id uuid primary key references auth.users (id) on delete cascade,
  employee_id text not null,
  email text not null,
  full_name text,
  created_at timestamptz not null default now(),
  constraint officers_employee_id_key unique (employee_id),
  constraint officers_email_key unique (email)
);

alter table public.officers enable row level security;

create policy "officers_select_own"
  on public.officers
  for select
  to authenticated
  using ((select auth.uid()) = id);

grant select on table public.officers to authenticated;

create or replace function public.handle_new_officer()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.raw_user_meta_data ->> 'employee_id' is null then
    return new;
  end if;

  insert into public.officers (id, employee_id, email, full_name)
  values (
    new.id,
    new.raw_user_meta_data ->> 'employee_id',
    lower(new.email),
    new.raw_user_meta_data ->> 'full_name'
  )
  on conflict (id) do update
    set employee_id = excluded.employee_id,
        email = excluded.email,
        full_name = excluded.full_name;

  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row
  execute function public.handle_new_officer();
