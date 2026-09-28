-- Подробная информация о винодельне для её страницы в приложении.
-- Пустые поля (null) приложение просто не показывает.

alter table public.wineries
  add column if not exists description       jsonb not null default '{}'::jsonb, -- {"ru": "...", "ro": "...", "en": "..."}
  add column if not exists address           text,
  add column if not exists phone             text,          -- в международном формате: +373 ...
  add column if not exists website           text,          -- https://...
  add column if not exists hours             jsonb not null default '{}'::jsonb, -- {"ru": "Пн–Сб 10:00–18:00", ...}
  add column if not exists has_tastings      boolean,       -- null — неизвестно
  add column if not exists tasting_price_lei numeric(10, 2) check (tasting_price_lei >= 0),
  add column if not exists booking_required  boolean,
  add column if not exists founded_year      integer check (founded_year between 1000 and 2100),
  add column if not exists image_url         text not null default '';
