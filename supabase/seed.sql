-- Начальные данные. Выполняется после миграции (или автоматически через `supabase db reset`).
-- Сгенерировано скриптом tool/gen_catalog_data.py (вместе с lib/data/mock_data.dart).

insert into public.wineries (id, name, latitude, longitude, region, founded_year, description) values
  (1, 'Château Vartely', 47.3833, 28.8167, 'Codru · Orhei', null,
   jsonb_build_object('ru', 'Современная винодельня у Орхея, в зоне Кодру. При ней работает туристический комплекс с гостиницей и рестораном.', 'ro', 'Vinărie modernă lângă Orhei, în zona Codru, cu un complex turistic care include hotel și restaurant.', 'en', 'A modern winery near Orhei in the Codru region, with a tourist complex that includes a hotel and a restaurant.')),
  (2, 'Château Purcari', 46.525, 29.865, 'Ștefan Vodă · Purcari', 1827,
   jsonb_build_object('ru', 'Одна из старейших виноделен Молдовы, основана в 1827 году на юге страны. Известна красным купажом Negru de Purcari.', 'ro', 'Una dintre cele mai vechi vinării din Moldova, fondată în 1827 în sudul țării. Cunoscută pentru cupajul roșu Negru de Purcari.', 'en', 'One of Moldova''s oldest wineries, founded in 1827 in the south of the country. Known for its red blend Negru de Purcari.')),
  (3, 'Cricova', 47.1386, 28.862, 'Codru · Cricova', 1952,
   jsonb_build_object('ru', 'Знаменита подземными винными галереями протяжённостью более 100 километров — настоящий винный город под землёй.', 'ro', 'Renumită pentru galeriile subterane de peste 100 de kilometri — un adevărat oraș al vinului sub pământ.', 'en', 'Famous for its underground wine galleries stretching over 100 kilometres — a true wine city beneath the ground.')),
  (4, 'Mileștii Mici', 46.905, 28.828, 'Codru · Ialoveni', 1969,
   jsonb_build_object('ru', 'Подземные галереи с огромной коллекцией вин, которая занесена в Книгу рекордов Гиннесса как крупнейшая в мире.', 'ro', 'Galerii subterane cu o colecție imensă de vinuri, înscrisă în Cartea Recordurilor Guinness drept cea mai mare din lume.', 'en', 'Underground galleries holding a vast wine collection listed in the Guinness World Records as the largest in the world.')),
  (5, 'Castel Mimi', 46.89, 29.305, 'Codru · Bulboaca', 1893,
   jsonb_build_object('ru', 'Винодельня в замке, построенном в конце XIX века Константином Мими. Сегодня здесь также ресторан и гостиница.', 'ro', 'Vinărie într-un castel construit la sfârșitul secolului XIX de Constantin Mimi, astăzi cu restaurant și hotel.', 'en', 'A winery in a castle built in the late 19th century by Constantin Mimi, now also home to a restaurant and a hotel.')),
  (6, 'Asconi', 46.825, 29.09, 'Codru · Puhoi', null,
   jsonb_build_object('ru', 'Семейная винодельня в селе Пуой, недалеко от Кишинёва, с рестораном в традиционном молдавском стиле.', 'ro', 'Vinărie de familie în satul Puhoi, aproape de Chișinău, cu un restaurant în stil tradițional moldovenesc.', 'en', 'A family winery in the village of Puhoi, near Chișinău, with a restaurant in traditional Moldovan style.')),
  (7, 'Et Cetera', 46.423, 29.93, 'Ștefan Vodă · Crocmaz', null,
   jsonb_build_object('ru', 'Небольшая семейная винодельня в селе Крокмаз на юге Молдовы, в регионе Штефан-Водэ.', 'ro', 'Vinărie mică de familie în satul Crocmaz, în sudul Moldovei, în regiunea Ștefan Vodă.', 'en', 'A small family winery in the village of Crocmaz in southern Moldova, in the Ștefan Vodă region.'))
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

insert into public.grapes (id, name, color, is_native, aliases, description, taste, sort_order) values
  ('feteasca-neagra', 'Fetească Neagră', 'red', true, '{}'::text[],
   jsonb_build_object('ru', 'Древний местный красный сорт, один из символов молдавского виноделия. Даёт насыщенные вина, которые хорошо раскрываются с выдержкой.', 'ro', 'Soi roșu autohton străvechi, unul dintre simbolurile vinificației moldovenești. Dă vinuri intense, care se dezvoltă frumos la învechire.', 'en', 'An ancient native red grape and one of the symbols of Moldovan winemaking. It gives rich wines that develop beautifully with age.'),
   jsonb_build_object('ru', 'Чернослив, спелая вишня, чёрная смородина, пряности.', 'ro', 'Prune uscate, cireșe coapte, coacăză neagră, condimente.', 'en', 'Prunes, ripe cherry, blackcurrant, spice.'), 10),
  ('rara-neagra', 'Rară Neagră', 'red', true, array['Băbească Neagră']::text[],
   jsonb_build_object('ru', 'Местный красный сорт, в Румынии известный как Бэбяскэ Нягрэ. Даёт лёгкие, мягкие вина с яркой ягодностью.', 'ro', 'Soi roșu autohton, cunoscut în România ca Băbească Neagră. Dă vinuri ușoare, catifelate, cu fructuozitate vie.', 'en', 'A native red grape known in Romania as Băbească Neagră. It makes light, soft wines with bright red fruit.'),
   jsonb_build_object('ru', 'Вишня, красные ягоды, лёгкие пряные ноты.', 'ro', 'Vișine, fructe roșii, note ușor condimentate.', 'en', 'Sour cherry, red berries, a hint of spice.'), 20),
  ('feteasca-alba', 'Fetească Albă', 'white', true, '{}'::text[],
   jsonb_build_object('ru', 'Старинный местный белый сорт. Вина получаются лёгкими и изящными, часто с тонким цветочным ароматом.', 'ro', 'Soi alb autohton vechi. Dă vinuri ușoare și elegante, adesea cu o aromă florală delicată.', 'en', 'An old native white grape producing light, elegant wines, often with a delicate floral aroma.'),
   jsonb_build_object('ru', 'Белые цветы, зелёное яблоко, персик.', 'ro', 'Flori albe, măr verde, piersică.', 'en', 'White flowers, green apple, peach.'), 30),
  ('feteasca-regala', 'Fetească Regală', 'white', true, '{}'::text[],
   jsonb_build_object('ru', 'Белый сорт, появившийся в XX веке как потомок Фетяски Албэ. Свежий и универсальный — от сухих вин до игристых.', 'ro', 'Soi alb apărut în secolul XX, descendent al Feteascăi Albe. Proaspăt și versatil — de la vinuri seci la spumante.', 'en', 'A white grape that appeared in the 20th century as a descendant of Fetească Albă. Fresh and versatile — from dry wines to sparkling.'),
   jsonb_build_object('ru', 'Цитрусы, груша, свежескошенная трава.', 'ro', 'Citrice, pară, iarbă proaspăt cosită.', 'en', 'Citrus, pear, freshly cut grass.'), 40),
  ('viorica', 'Viorica', 'white', true, '{}'::text[],
   jsonb_build_object('ru', 'Ароматный белый сорт, выведенный в Молдове во второй половине XX века. Узнаётся по яркому мускатному аромату.', 'ro', 'Soi alb aromat, creat în Moldova în a doua jumătate a secolului XX. Se recunoaște după aroma intensă de muscat.', 'en', 'An aromatic white grape bred in Moldova in the second half of the 20th century, recognisable by its vivid muscat aroma.'),
   jsonb_build_object('ru', 'Мускат, липа, цитрусы, тропические фрукты.', 'ro', 'Muscat, tei, citrice, fructe tropicale.', 'en', 'Muscat, linden blossom, citrus, tropical fruit.'), 50),
  ('cabernet-sauvignon', 'Cabernet Sauvignon', 'red', false, '{}'::text[],
   jsonb_build_object('ru', 'Самый известный красный сорт в мире и один из самых распространённых в Молдове. Плотные, танинные вина для выдержки.', 'ro', 'Cel mai cunoscut soi roșu din lume și unul dintre cele mai răspândite în Moldova. Vinuri dense, taninoase, potrivite pentru învechire.', 'en', 'The world''s best-known red grape and one of the most planted in Moldova. Full, tannic wines built for ageing.'),
   jsonb_build_object('ru', 'Чёрная смородина, вишня, табак, кедр.', 'ro', 'Coacăză neagră, cireșe, tutun, cedru.', 'en', 'Blackcurrant, cherry, tobacco, cedar.'), 60),
  ('merlot', 'Merlot', 'red', false, '{}'::text[],
   jsonb_build_object('ru', 'Мягкий и бархатистый красный сорт, часто встречается в купажах с Каберне.', 'ro', 'Soi roșu moale și catifelat, des întâlnit în cupaje cu Cabernet.', 'en', 'A soft, velvety red grape, often blended with Cabernet.'),
   jsonb_build_object('ru', 'Слива, вишня, шоколад.', 'ro', 'Prune, cireșe, ciocolată.', 'en', 'Plum, cherry, chocolate.'), 70),
  ('pinot-noir', 'Pinot Noir', 'red', false, '{}'::text[],
   jsonb_build_object('ru', 'Капризный, но изысканный красный сорт. Даёт лёгкие элегантные вина и служит основой многих игристых.', 'ro', 'Soi roșu pretențios, dar rafinat. Dă vinuri ușoare și elegante și stă la baza multor spumante.', 'en', 'A demanding but refined red grape, giving light, elegant wines and forming the base of many sparkling wines.'),
   jsonb_build_object('ru', 'Клубника, малина, вишня, лесные ноты.', 'ro', 'Căpșuni, zmeură, cireșe, note de pădure.', 'en', 'Strawberry, raspberry, cherry, forest floor.'), 80),
  ('chardonnay', 'Chardonnay', 'white', false, '{}'::text[],
   jsonb_build_object('ru', 'Один из самых популярных белых сортов в мире. Бывает и свежим, и насыщенным после выдержки в дубе; основа классических игристых.', 'ro', 'Unul dintre cele mai populare soiuri albe din lume. Poate fi proaspăt sau bogat după învechire în stejar; bază pentru spumantele clasice.', 'en', 'One of the world''s most popular white grapes — fresh or rich after oak ageing, and a base for classic sparkling wines.'),
   jsonb_build_object('ru', 'Яблоко, груша, цитрусы, ваниль (после дуба).', 'ro', 'Măr, pară, citrice, vanilie (după stejar).', 'en', 'Apple, pear, citrus, vanilla (when oaked).'), 90),
  ('sauvignon-blanc', 'Sauvignon Blanc', 'white', false, '{}'::text[],
   jsonb_build_object('ru', 'Свежий ароматный белый сорт с яркой кислотностью.', 'ro', 'Soi alb proaspăt și aromat, cu aciditate vie.', 'en', 'A fresh, aromatic white grape with lively acidity.'),
   jsonb_build_object('ru', 'Крыжовник, лайм, зелёный перец, трава.', 'ro', 'Agrișe, lime, ardei verde, iarbă.', 'en', 'Gooseberry, lime, green pepper, grass.'), 100)
on conflict (id) do nothing;

-- id заданы вручную — сдвигаем счётчики, чтобы новые записи не конфликтовали
select setval(pg_get_serial_sequence('public.wineries', 'id'), (select max(id) from public.wineries));
select setval(pg_get_serial_sequence('public.wines', 'id'), (select max(id) from public.wines));
