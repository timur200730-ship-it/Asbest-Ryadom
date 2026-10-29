-- Стартовая схема для Supabase. Применяйте только в отдельном проекте.
-- Перед production запуском проверьте все политики, grants и тесты RLS.
create extension if not exists pgcrypto;

create table if not exists public.organizations (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  category text not null,
  description text not null default '',
  address text not null default '',
  phone text,
  website text,
  opening_hours text,
  latitude double precision,
  longitude double precision,
  image_path text,
  published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.events (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  category text not null,
  description text not null default '',
  starts_at timestamptz,
  ends_at timestamptz,
  address text not null default '',
  latitude double precision,
  longitude double precision,
  price_text text,
  organizer text,
  registration_url text,
  image_path text,
  published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.organizations enable row level security;
alter table public.events enable row level security;

-- Публичное чтение только опубликованных карточек.
create policy "Public can read published organizations"
  on public.organizations for select to anon, authenticated
  using (published = true);
create policy "Public can read published events"
  on public.events for select to anon, authenticated
  using (published = true);

-- ВАЖНО: намеренно не добавлены публичные INSERT/UPDATE/DELETE политики.
-- Админ-операции следует реализовать через authenticated-роль с отдельной
-- таблицей ролей/проверенной функцией либо через Edge Function на сервере.
-- Никогда не помещайте service_role key в клиентский JavaScript.
