-- Справочник сортов винограда.
-- Вина связываются с сортом по названию в wines.grape_variety
-- (с учётом aliases, без учёта регистра и диакритик) — отдельная связь не нужна.

create table if not exists public.grapes (
  id           text primary key,                      -- код: 'feteasca-neagra'
  name         text not null unique,                  -- как на этикетке: 'Fetească Neagră'
  color        text not null check (color in ('red', 'white')),
  is_native    boolean not null default false,        -- местный молдавский сорт
  aliases      text[] not null default '{}',          -- другие названия: '{"Băbească Neagră"}'
  description  jsonb not null default '{}'::jsonb,    -- {"ru": "...", "ro": "...", "en": "..."}
  taste        jsonb not null default '{}'::jsonb,    -- ароматы и вкус на трёх языках
  image_url    text not null default '',
  sort_order   integer not null default 100,          -- порядок в списке (меньше — выше)
  created_at   timestamptz not null default now()
);

alter table public.grapes enable row level security;

drop policy if exists "Сорта видны всем" on public.grapes;
create policy "Сорта видны всем"
  on public.grapes for select
  to anon, authenticated
  using (true);
