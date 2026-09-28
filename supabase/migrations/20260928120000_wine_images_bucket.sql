-- Публичный бакет для фото вин.
-- Читать файлы может кто угодно (по публичной ссылке), загружать — только
-- через панель Supabase: политик на запись для приложения нет.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'wine-images',
  'wine-images',
  true,
  5242880, -- 5 МБ
  array['image/jpeg', 'image/png', 'image/webp']
)
on conflict (id) do nothing;
