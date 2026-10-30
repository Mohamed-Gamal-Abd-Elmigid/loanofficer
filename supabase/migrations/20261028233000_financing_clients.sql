create table public.financing_clients (
  id uuid primary key default gen_random_uuid(),
  national_id text not null,
  created_by uuid not null references auth.users (id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint financing_clients_national_id_key unique (national_id),
  constraint financing_clients_national_id_len check (char_length(national_id) = 14)
);

create table public.client_basic_profiles (
  client_id uuid primary key references public.financing_clients (id) on delete cascade,
  client_number text,
  full_name text,
  first_name text,
  second_name text,
  third_name text,
  fourth_name text,
  nickname text,
  birth_date text,
  id_issue_date text,
  id_expiry_date text,
  gender text,
  health text,
  job text,
  religion text,
  nationality text,
  marital_status text,
  children text,
  education text,
  updated_at timestamptz not null default now()
);

create table public.client_residence_addresses (
  client_id uuid primary key references public.financing_clients (id) on delete cascade,
  governorate text,
  city text,
  district text,
  street text,
  building text,
  floor text,
  apartment text,
  landmark text,
  postal_code text,
  updated_at timestamptz not null default now()
);

create table public.client_card_addresses (
  client_id uuid primary key references public.financing_clients (id) on delete cascade,
  governorate text,
  city text,
  district text,
  street text,
  building text,
  floor text,
  apartment text,
  landmark text,
  postal_code text,
  updated_at timestamptz not null default now()
);

create table public.client_contacts (
  client_id uuid primary key references public.financing_clients (id) on delete cascade,
  phone_1 text,
  phone_2 text,
  email text,
  updated_at timestamptz not null default now()
);

alter table public.financing_clients enable row level security;
alter table public.client_basic_profiles enable row level security;
alter table public.client_residence_addresses enable row level security;
alter table public.client_card_addresses enable row level security;
alter table public.client_contacts enable row level security;

create policy financing_clients_select
  on public.financing_clients
  for select
  to authenticated
  using (true);

create policy financing_clients_insert
  on public.financing_clients
  for insert
  to authenticated
  with check ((select auth.uid()) = created_by);

create policy financing_clients_update
  on public.financing_clients
  for update
  to authenticated
  using (true)
  with check (true);

create policy client_basic_profiles_all
  on public.client_basic_profiles
  for all
  to authenticated
  using (true)
  with check (true);

create policy client_residence_addresses_all
  on public.client_residence_addresses
  for all
  to authenticated
  using (true)
  with check (true);

create policy client_card_addresses_all
  on public.client_card_addresses
  for all
  to authenticated
  using (true)
  with check (true);

create policy client_contacts_all
  on public.client_contacts
  for all
  to authenticated
  using (true)
  with check (true);

grant select, insert, update on table public.financing_clients to authenticated;
grant select, insert, update, delete on table public.client_basic_profiles to authenticated;
grant select, insert, update, delete on table public.client_residence_addresses to authenticated;
grant select, insert, update, delete on table public.client_card_addresses to authenticated;
grant select, insert, update, delete on table public.client_contacts to authenticated;
