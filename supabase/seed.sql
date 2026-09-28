-- Начальные данные. Выполняется после миграции (или автоматически через `supabase db reset`).
-- Сгенерировано скриптом tool/gen_catalog_data.py (вместе с lib/data/mock_data.dart).

insert into public.wineries (id, name, latitude, longitude, region) values
  (1, 'Château Vartely', 47.3833, 28.8167, 'Codru · Orhei'),
  (2, 'Château Purcari', 46.525, 29.865, 'Ștefan Vodă · Purcari'),
  (3, 'Cricova', 47.1386, 28.862, 'Codru · Cricova'),
  (4, 'Mileștii Mici', 46.905, 28.828, 'Codru · Ialoveni'),
  (5, 'Castel Mimi', 46.89, 29.305, 'Codru · Bulboaca'),
  (6, 'Asconi', 46.825, 29.09, 'Codru · Puhoi'),
  (7, 'Et Cetera', 46.423, 29.93, 'Ștefan Vodă · Crocmaz')
on conflict (id) do nothing;

insert into public.wines (id, winery_id, name, type, grape_variety, vintage, rating, avg_price_lei, image_url, description) values
  (1, 1, 'Fetească Neagră Premium', 'red_dry', 'Fetească Neagră', 2020, 4.8, 180, '',
   jsonb_build_object('ru', 'Богатый аромат спелой вишни, чернослива и сафьяновой кожи.', 'ro', 'Arome bogate de cireșe coapte, prune uscate și piele fină.', 'en', 'Rich aromas of ripe cherry, prunes and fine leather.')),
  (2, 2, 'Viorica de Purcari', 'white_dry', 'Viorica', 2023, 4.9, 145, '',
   jsonb_build_object('ru', 'Свежий вкус с нотами муската, цитрусовых и белых цветов.', 'ro', 'Gust proaspăt cu note de muscat, citrice și flori albe.', 'en', 'Fresh taste with notes of muscat, citrus and white flowers.')),
  (3, 1, 'Rară Neagră Taraboste', 'red_dry', 'Rară Neagră', 2019, 4.7, 320, '',
   jsonb_build_object('ru', 'Выдержанное вино с оттенками сухофруктов и дуба.', 'ro', 'Vin maturat cu nuanțe de fructe uscate și stejar.', 'en', 'An aged wine with hints of dried fruit and oak.')),
  (4, 3, 'Cricova Brut', 'sparkling', 'Chardonnay, Pinot Noir', 2021, 4.6, 210, '',
   jsonb_build_object('ru', 'Классическое игристое с тонкой перлажью, нотами яблока и бриоши.', 'ro', 'Spumant clasic cu perlaj fin, note de măr și brioșă.', 'en', 'A classic sparkling wine with fine bubbles and notes of apple and brioche.')),
  (5, 5, 'Rosé de Mimi', 'rose_dry', 'Pinot Noir', 2023, 4.5, 190, '',
   jsonb_build_object('ru', 'Лёгкое розовое с ароматом клубники, малины и цветов.', 'ro', 'Rose ușor cu arome de căpșuni, zmeură și flori.', 'en', 'A light rosé with aromas of strawberry, raspberry and flowers.')),
  (6, 6, 'Asconi Sauvignon Blanc', 'white_dry', 'Sauvignon Blanc', 2023, 4.4, 130, '',
   jsonb_build_object('ru', 'Хрустящее белое с нотами крыжовника, лайма и свежей травы.', 'ro', 'Alb crocant cu note de agrișe, lime și iarbă proaspătă.', 'en', 'A crisp white with notes of gooseberry, lime and fresh grass.')),
  (7, 7, 'Et Cetera Merlot', 'red_dry', 'Merlot', 2020, 4.6, 250, '',
   jsonb_build_object('ru', 'Мягкое бархатистое красное со спелой сливой и шоколадом.', 'ro', 'Roșu moale și catifelat, cu prune coapte și ciocolată.', 'en', 'A soft, velvety red with ripe plum and chocolate.')),
  (8, 4, 'Mileștii Mici Cabernet Sauvignon', 'red_dry', 'Cabernet Sauvignon', 2018, 4.7, 280, '',
   jsonb_build_object('ru', 'Выдержанное в подвалах вино с тонами чёрной смородины и табака.', 'ro', 'Vin maturat în beciuri, cu tonuri de coacăză neagră și tutun.', 'en', 'Aged in underground cellars, with tones of blackcurrant and tobacco.'))
on conflict (id) do nothing;

-- id заданы вручную — сдвигаем счётчики, чтобы новые записи не конфликтовали
select setval(pg_get_serial_sequence('public.wineries', 'id'), (select max(id) from public.wineries));
select setval(pg_get_serial_sequence('public.wines', 'id'), (select max(id) from public.wines));
