-- Вино однозначно определяется винодельней, названием и годом урожая.
-- Нужно, чтобы импорт из таблицы (tool/catalog_sheet.py) обновлял существующие
-- вина, а не создавал дубли. Без года (NV) — тоже одно значение (nulls not distinct).
do $$
begin
  if not exists (select 1 from pg_constraint where conname = 'wines_winery_name_vintage_key') then
    alter table public.wines
      add constraint wines_winery_name_vintage_key unique nulls not distinct (winery_id, name, vintage);
  end if;
end $$;
