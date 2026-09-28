-- Импорт каталога из «agent2_new», 2026-09-28 17:53.
-- Виноделен: 10, вин: 16. Supabase → SQL Editor → Run.
-- Всё в одной транзакции: при ошибке ничего не изменится.
begin;

-- Вино определяется винодельней + названием + годом (нужно для обновления)
do $$
begin
  if not exists (select 1 from pg_constraint where conname = 'wines_winery_name_vintage_key') then
    alter table public.wines
      add constraint wines_winery_name_vintage_key unique nulls not distinct (winery_id, name, vintage);
  end if;
end $$;

insert into public.wineries (name, region, latitude, longitude, founded_year, address, phone, website,
  hours, has_tastings, tasting_price_lei, booking_required, description, image_url) values
  ('BASAVIN Winery', 'Valul lui Traian · Basarabeasca', 46.3588, 28.8947, 1913::integer, 'str. Karl Marx 205, Basarabeasca, Republica Moldova', '+373 60 65 00 52', 'https://basavin.md',
   '{"ru": "Пн–Пт 09:00–18:00", "ro": "Lun–Vin 09:00–18:00", "en": "Mon–Fri 09:00–18:00"}'::jsonb, null, null::numeric, true,
   '{"ru": "Винодельня с более чем вековой историей. Производит широкий ассортимент сухих и десертных вин.", "ro": "Vinărie cu o istorie de peste un secol. Produce o gamă largă de vinuri seci și de desert.", "en": "Winery with over a century of history. Produces a wide range of dry and dessert wines."}'::jsonb, ''),
  ('Carlevana Winery', 'Codru · Merenii Noi', 46.9261, 29.0528, 1959::integer, 'str. Ștefan cel Mare 9, s. Merenii Noi, r. Anenii Noi, MD-2065', '+373 767 555 50', 'https://carlevana.md',
   '{"ru": "Чт–Вс 11:00, 13:00, 15:00 (дегустации по сеансам)", "ro": "Joi–Dum 11:00, 13:00, 15:00 (degustări pe sesiuni)", "en": "Thu–Sun 11:00, 13:00, 15:00 (scheduled tasting slots)"}'::jsonb, true, 400.0::numeric, null,
   '{"ru": "Винодельня с историей с 1959 года. Известна своими винами из местных сортов, включая Rară Neagră и Fetească Neagră.", "ro": "Vinărie cu istorie din 1959. Cunoscută pentru vinurile din soiuri locale, inclusiv Rară Neagră și Fetească Neagră.", "en": "Winery with history dating back to 1959. Known for its wines from local varieties, including Rară Neagră and Fetească Neagră."}'::jsonb, ''),
  ('Crama Tudor', 'Codru · Sadova', 47.1924, 28.3511, 2000::integer, 's. Sadova, r. Călărași', '+373 69 763 771', null,
   '{}'::jsonb, true, null::numeric, true,
   '{"ru": "Небольшая семейная винодельня, основанная виноделом Тудором Агенией. Производит вина из местных и международных сортов.", "ro": "Vinărie mică de familie fondată de vinificatorul Tudor Aghenie. Produce vinuri din soiuri locale și internaționale.", "en": "Small family winery founded by winemaker Tudor Aghenie. Produces wines from local and international varieties."}'::jsonb, ''),
  ('Doina Vin', 'Codru · Răzeni', 46.7587, 28.9227, 1875::integer, 's. Răzeni, r. Ialoveni', '+373 22 22 85 73', 'https://doinavin.md',
   '{}'::jsonb, null, null::numeric, null,
   '{"ru": "Одна из старейших виноделен Молдовы с традициями с 1875 года. Проводят туры по историческим подвалам.", "ro": "Una dintre cele mai vechi vinării din Moldova cu tradiții din 1875. Oferă tururi prin cramele istorice.", "en": "One of the oldest wineries in Moldova with traditions dating back to 1875. Offers tours of historic cellars."}'::jsonb, ''),
  ('Javgur Winery', 'Valul lui Traian · Ialpujeni', 46.5396, 28.6116, 1957::integer, 's. Ialpujeni, r. Cimișlia', '+373 69 500 300', null,
   '{"ru": "Пт–Вс 11:00–19:00", "ro": "Vin–Dum 11:00–19:00", "en": "Fri–Sun 11:00–19:00"}'::jsonb, true, null::numeric, true,
   '{"ru": "Семейная винодельня, основанная в 1957 году. Расположена вдоль древнего Траянова вала.", "ro": "Vinărie de familie fondată în 1957. Situată de-a lungul vechiului Val al lui Traian.", "en": "Family winery founded in 1957. Located along the ancient Trajan''s Wall."}'::jsonb, ''),
  ('Kazayak-Vin', 'Valul lui Traian · Cazaclia', 46.0061, 28.6628, 1958::integer, 'str. Lenin 2, s. Cazaclia, UTA Găgăuzia', '+373 22 229 198', null,
   '{}'::jsonb, null, null::numeric, null,
   '{"ru": "Крупный производитель и экспортёр вина, основанный в 1958 году. Производит вина из местных и международных сортов.", "ro": "Producător și exportator major de vin, fondat în 1958. Produce vinuri din soiuri locale și internaționale.", "en": "Major wine producer and exporter founded in 1958. Produces wines from local and international varieties."}'::jsonb, ''),
  ('Mihai Sava Winery', 'Codru · Costești', 46.86092, 28.77016, 2016::integer, 's. Costești, r. Ialoveni', '+373 69 309 134', null,
   '{"ru": "Пн–Вс 14:00–20:00", "ro": "Lun–Dum 14:00–20:00", "en": "Mon–Sun 14:00–20:00"}'::jsonb, true, null::numeric, true,
   '{"ru": "Микровинодельня, основанная виноделом Михаем Сава. Производит вина из местных сортов, каждое вино сопровождается стихотворением.", "ro": "Microvinărie fondată de vinificatorul Mihai Sava. Produce vinuri din soiuri locale, fiecare vin fiind însoțit de o poezie.", "en": "Micro-winery founded by winemaker Mihai Sava. Produces wines from local varieties, each wine accompanied by a poem."}'::jsonb, ''),
  ('Salcuta Winery', 'Ștefan Vodă · Sălcuța', 46.5833, 29.2, 1995::integer, 'str. Pavel Creangă 3, s. Sălcuța, r. Căușeni, MD-4323', '+373 22 245 252', 'https://salcutawine.md',
   '{}'::jsonb, null, null::numeric, null,
   '{"ru": "Единственная винодельня в Молдове, наследие которой передаётся через три поколения. Расположена в регионе Ștefan Vodă.", "ro": "Singura vinărie din Moldova cu moștenire transmisă prin trei generații. Situată în regiunea Ștefan Vodă.", "en": "The only winery in Moldova with a legacy passed through three generations. Located in the Ștefan Vodă region."}'::jsonb, ''),
  ('Tronciu Wines', 'Codru · Pereni', 46.99999, 28.37473, 2018::integer, 's. Pereni, r. Hîncești', '+373 68 056 213', null,
   '{"ru": "Пн–Вс 10:00–21:00", "ro": "Lun–Dum 10:00–21:00", "en": "Mon–Sun 10:00–21:00"}'::jsonb, true, null::numeric, true,
   '{"ru": "Небольшая семейная винодельня, основанная Николаем Трончу. Производит органические вина из местных и международных сортов.", "ro": "Vinărie mică de familie fondată de Nicolae Tronciu. Produce vinuri ecologice din soiuri locale și internaționale.", "en": "Small family winery founded by Nicolae Tronciu. Produces organic wines from local and international varieties."}'::jsonb, ''),
  ('Vinaria din Vale', 'Valul lui Traian · Slobozia Mare', 45.57682, 28.17621, 2001::integer, 's. Slobozia Mare, r. Cahul', '+373 68 464 647', 'https://vinariadinvale.com',
   '{"ru": "Пн–Пт 10:00–18:00", "ro": "Lun–Vin 10:00–18:00", "en": "Mon–Fri 10:00–18:00"}'::jsonb, true, null::numeric, true,
   '{"ru": "Крупный производитель и экспортёр вин, основанный в 2001 году. Расположен в биосферном заповеднике Lunca Prutului de Jos.", "ro": "Producător și exportator major de vinuri, fondat în 2001. Situat în rezervația biosferei Lunca Prutului de Jos.", "en": "Major wine producer and exporter founded in 2001. Located in the Lunca Prutului de Jos biosphere reserve."}'::jsonb, '')
on conflict (name) do update set
  region            = coalesce(excluded.region, wineries.region),
  latitude          = excluded.latitude,
  longitude         = excluded.longitude,
  founded_year      = coalesce(excluded.founded_year, wineries.founded_year),
  address           = coalesce(excluded.address, wineries.address),
  phone             = coalesce(excluded.phone, wineries.phone),
  website           = coalesce(excluded.website, wineries.website),
  hours             = wineries.hours || excluded.hours,
  has_tastings      = coalesce(excluded.has_tastings, wineries.has_tastings),
  tasting_price_lei = coalesce(excluded.tasting_price_lei, wineries.tasting_price_lei),
  booking_required  = coalesce(excluded.booking_required, wineries.booking_required),
  description       = wineries.description || excluded.description,
  image_url         = case when excluded.image_url <> '' then excluded.image_url else wineries.image_url end;

insert into public.wines (winery_id, name, type, grape_variety, vintage, rating, avg_price_lei, image_url, description)
select w.id, v.name, v.type, v.grape_variety, v.vintage, v.rating, v.price, v.image_url, v.description
from (values
  ('BASAVIN Winery'::text, 'Chateau du Basavines Cabernet Sauvignon'::text, 'red_dry'::text, 'Cabernet Sauvignon'::text, 2018::integer, null::numeric, 120.0::numeric, ''::text,
   '{"ru": "Вино с нотами чёрной смородины и вишни, элегантное.", "ro": "Vin cu note de coacăze negre și cireșe, elegant.", "en": "Wine with notes of blackcurrant and cherry, elegant."}'::jsonb),
  ('BASAVIN Winery'::text, 'Cabernet'::text, 'red_dry'::text, 'Cabernet'::text, 2020::integer, null::numeric, 100.0::numeric, ''::text,
   '{"ru": "Гранатовый цвет, средняя терпкость, ноты красных фруктов.", "ro": "Culoare granată, astringență medie, note de fructe roșii.", "en": "Garnet color, medium astringency, red fruit notes."}'::jsonb),
  ('Carlevana Winery'::text, 'Raritet Rara Neagra'::text, 'red_dry'::text, 'Rară Neagră'::text, 2020::integer, null::numeric, 200.0::numeric, ''::text,
   '{"ru": "Вино с нотами чёрных фруктов и специй, полнотелое.", "ro": "Vin cu note de fructe negre și condimente, corpulent.", "en": "Wine with notes of black fruits and spices, full-bodied."}'::jsonb),
  ('Carlevana Winery'::text, 'Renaissance Muscat'::text, 'white_dry'::text, 'Muscat'::text, 2022::integer, null::numeric, 180.0::numeric, ''::text,
   '{"ru": "Ароматное вино с нотами муската и белых цветов.", "ro": "Vin aromat cu note de muscat și flori albe.", "en": "Aromatic wine with notes of muscat and white flowers."}'::jsonb),
  ('Crama Tudor'::text, 'Fetească Regală'::text, 'white_dry'::text, 'Fetească Regală'::text, 2024::integer, null::numeric, 120.0::numeric, ''::text,
   '{"ru": "Свежее вино с нотами белых цветов и яблок.", "ro": "Vin proaspăt cu note de flori albe și mere.", "en": "Fresh wine with notes of white flowers and apples."}'::jsonb),
  ('Crama Tudor'::text, 'Chardonnay'::text, 'white_dry'::text, 'Chardonnay'::text, 2023::integer, null::numeric, 130.0::numeric, ''::text,
   '{"ru": "Вино с нотами цитрусовых и лёгкими дубовыми нотками.", "ro": "Vin cu note citrice și ușoare note de stejar.", "en": "Wine with citrus notes and light oak nuances."}'::jsonb),
  ('Doina Vin'::text, 'Premium Chardonnay'::text, 'white_dry'::text, 'Chardonnay'::text, 2022::integer, null::numeric, 150.0::numeric, ''::text,
   '{"ru": "Элегантное вино с нотами жёлтых яблок и цитрусовых.", "ro": "Vin elegant cu note de mere galbene și citrice.", "en": "Elegant wine with notes of yellow apples and citrus."}'::jsonb),
  ('Javgur Winery'::text, 'Pastoral de Javgur'::text, 'red_dry'::text, 'Feteasca Neagra, Saperavi'::text, 2014::integer, null::numeric, 250.0::numeric, ''::text,
   '{"ru": "Вино с нотами спелых чёрных фруктов и специй.", "ro": "Vin cu note de fructe negre coapte și condimente.", "en": "Wine with ripe black fruit and spice notes."}'::jsonb),
  ('Kazayak-Vin'::text, 'Pinot Noir'::text, 'red_dry'::text, 'Pinot Noir'::text, 2019::integer, null::numeric, 120.0::numeric, ''::text,
   '{"ru": "Вино с нотами красных ягод и специй, золотая медаль Concours Mondial de Bruxelles.", "ro": "Vin cu note de fructe roșii și condimente, medalie de aur Concours Mondial de Bruxelles.", "en": "Wine with red berry and spice notes, gold medal Concours Mondial de Bruxelles."}'::jsonb),
  ('Mihai Sava Winery'::text, 'Bianca'::text, 'white_dry'::text, 'Bianca'::text, 2023::integer, null::numeric, 150.0::numeric, ''::text,
   '{"ru": "Деликатное вино с нотами белых цветов и цитрусовых.", "ro": "Vin delicat cu note de flori albe și citrice.", "en": "Delicate wine with notes of white flowers and citrus."}'::jsonb),
  ('Mihai Sava Winery'::text, 'Cabernet Sauvignon'::text, 'red_dry'::text, 'Cabernet Sauvignon'::text, 2022::integer, null::numeric, 180.0::numeric, ''::text,
   '{"ru": "Вино с нотами чёрной смородины и специй.", "ro": "Vin cu note de coacăze negre și condimente.", "en": "Wine with notes of blackcurrant and spices."}'::jsonb),
  ('Salcuta Winery'::text, 'Feteasca Neagră'::text, 'red_dry'::text, 'Fetească Neagră'::text, 2020::integer, null::numeric, 180.0::numeric, ''::text,
   '{"ru": "Вино с нотами чёрных фруктов и специй, рубиновый цвет.", "ro": "Vin cu note de fructe negre și condimente, culoare rubinie.", "en": "Wine with notes of black fruits and spices, ruby color."}'::jsonb),
  ('Salcuta Winery'::text, 'Chardonnay'::text, 'white_dry'::text, 'Chardonnay'::text, 2022::integer, null::numeric, 227.0::numeric, ''::text,
   '{"ru": "Вино с нотами дыни и грейпфрута, кремовые нюансы.", "ro": "Vin cu note de pepene galben și grepfrut, nuanțe cremoase.", "en": "Wine with notes of melon and grapefruit, creamy nuances."}'::jsonb),
  ('Tronciu Wines'::text, 'Feteasca Neagra'::text, 'red_dry'::text, 'Fetească Neagră'::text, 2021::integer, null::numeric, 150.0::numeric, ''::text,
   '{"ru": "Вино с нотами чёрных фруктов и специй, органическое.", "ro": "Vin cu note de fructe negre și condimente, ecologic.", "en": "Wine with notes of black fruits and spices, organic."}'::jsonb),
  ('Vinaria din Vale'::text, 'Premium Feteasca Neagra'::text, 'red_dry'::text, 'Fetească Neagră'::text, 2020::integer, null::numeric, 119.0::numeric, ''::text,
   '{"ru": "Вино с нотами чёрных фруктов и кофе, полнотелое.", "ro": "Vin cu note de fructe negre și cafea, corpulent.", "en": "Wine with notes of black fruits and coffee, full-bodied."}'::jsonb),
  ('Vinaria din Vale'::text, '7 Coline Feteasca Neagra Cabernet Sauvignon'::text, 'red_dry'::text, 'Fetească Neagră, Cabernet Sauvignon'::text, 2018::integer, null::numeric, 150.0::numeric, ''::text,
   '{"ru": "Гармоничное вино с нотами красной сливы и чёрной смородины.", "ro": "Vin armonios cu note de prune roșii și coacăze negre.", "en": "Harmonious wine with notes of red plum and blackcurrant."}'::jsonb)
) as v (winery, name, type, grape_variety, vintage, rating, price, image_url, description)
join public.wineries w on w.name = v.winery
on conflict on constraint wines_winery_name_vintage_key do update set
  type          = excluded.type,
  grape_variety = case when excluded.grape_variety <> '' then excluded.grape_variety else wines.grape_variety end,
  rating        = coalesce(excluded.rating, wines.rating),
  avg_price_lei = coalesce(excluded.avg_price_lei, wines.avg_price_lei),
  image_url     = case when excluded.image_url <> '' then excluded.image_url else wines.image_url end,
  description   = wines.description || excluded.description;

commit;
