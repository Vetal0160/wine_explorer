-- Винные маршруты: готовые поездки по нескольким винодельням по порядку.
create table if not exists public.routes (
  id           text primary key,                       -- код: 'codru-cellars'
  title        jsonb not null default '{}'::jsonb,     -- {"ru": "...", "ro": "...", "en": "..."}
  description  jsonb not null default '{}'::jsonb,
  duration     jsonb not null default '{}'::jsonb,     -- {"ru": "1 день", ...}
  winery_ids   bigint[] not null default '{}',         -- остановки по порядку
  image_url    text not null default '',
  sort_order   integer not null default 100,
  created_at   timestamptz not null default now()
);

alter table public.routes enable row level security;

drop policy if exists "Маршруты видны всем" on public.routes;
create policy "Маршруты видны всем"
  on public.routes for select
  to anon, authenticated
  using (true);
