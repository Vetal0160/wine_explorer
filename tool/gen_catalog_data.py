"""Генерирует lib/data/mock_data.dart и supabase/seed.sql из одного источника.

Запуск: python tool/gen_catalog_data.py
"""
import os
import sys

# Корень проекта — на уровень выше папки tool/
ROOT = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "")

IMG_RED = ""
IMG_WHITE = ""
IMG_AGED = ""

# id, name, lat, lng, region
WINERIES = [
    (1, "Château Vartely", 47.3833, 28.8167, "Codru · Orhei"),
    (2, "Château Purcari", 46.5250, 29.8650, "Ștefan Vodă · Purcari"),
    (3, "Cricova", 47.1386, 28.8620, "Codru · Cricova"),
    (4, "Mileștii Mici", 46.9050, 28.8280, "Codru · Ialoveni"),
    (5, "Castel Mimi", 46.8900, 29.3050, "Codru · Bulboaca"),
    (6, "Asconi", 46.8250, 29.0900, "Codru · Puhoi"),
    (7, "Et Cetera", 46.4230, 29.9300, "Ștefan Vodă · Crocmaz"),
]
WINERY_NAME = {w[0]: w[1] for w in WINERIES}

# Описания — по общеизвестным фактам, перед релизом стоит сверить с сайтами виноделен.
# Телефоны, часы работы и цены дегустаций не выдумываем — заполняются в Supabase.
WINERY_DETAILS = {
    1: {"founded": None, "description": {
        "ru": "Современная винодельня у Орхея, в зоне Кодру. При ней работает туристический комплекс с гостиницей и рестораном.",
        "ro": "Vinărie modernă lângă Orhei, în zona Codru, cu un complex turistic care include hotel și restaurant.",
        "en": "A modern winery near Orhei in the Codru region, with a tourist complex that includes a hotel and a restaurant."}},
    2: {"founded": 1827, "description": {
        "ru": "Одна из старейших виноделен Молдовы, основана в 1827 году на юге страны. Известна красным купажом Negru de Purcari.",
        "ro": "Una dintre cele mai vechi vinării din Moldova, fondată în 1827 în sudul țării. Cunoscută pentru cupajul roșu Negru de Purcari.",
        "en": "One of Moldova's oldest wineries, founded in 1827 in the south of the country. Known for its red blend Negru de Purcari."}},
    3: {"founded": 1952, "description": {
        "ru": "Знаменита подземными винными галереями протяжённостью более 100 километров — настоящий винный город под землёй.",
        "ro": "Renumită pentru galeriile subterane de peste 100 de kilometri — un adevărat oraș al vinului sub pământ.",
        "en": "Famous for its underground wine galleries stretching over 100 kilometres — a true wine city beneath the ground."}},
    4: {"founded": 1969, "description": {
        "ru": "Подземные галереи с огромной коллекцией вин, которая занесена в Книгу рекордов Гиннесса как крупнейшая в мире.",
        "ro": "Galerii subterane cu o colecție imensă de vinuri, înscrisă în Cartea Recordurilor Guinness drept cea mai mare din lume.",
        "en": "Underground galleries holding a vast wine collection listed in the Guinness World Records as the largest in the world."}},
    5: {"founded": 1893, "description": {
        "ru": "Винодельня в замке, построенном в конце XIX века Константином Мими. Сегодня здесь также ресторан и гостиница.",
        "ro": "Vinărie într-un castel construit la sfârșitul secolului XIX de Constantin Mimi, astăzi cu restaurant și hotel.",
        "en": "A winery in a castle built in the late 19th century by Constantin Mimi, now also home to a restaurant and a hotel."}},
    6: {"founded": None, "description": {
        "ru": "Семейная винодельня в селе Пуой, недалеко от Кишинёва, с рестораном в традиционном молдавском стиле.",
        "ro": "Vinărie de familie în satul Puhoi, aproape de Chișinău, cu un restaurant în stil tradițional moldovenesc.",
        "en": "A family winery in the village of Puhoi, near Chișinău, with a restaurant in traditional Moldovan style."}},
    7: {"founded": None, "description": {
        "ru": "Небольшая семейная винодельня в селе Крокмаз на юге Молдовы, в регионе Штефан-Водэ.",
        "ro": "Vinărie mică de familie în satul Crocmaz, în sudul Moldovei, în regiunea Ștefan Vodă.",
        "en": "A small family winery in the village of Crocmaz in southern Moldova, in the Ștefan Vodă region."}},
}

# Справочник сортов: id, название, цвет, местный?, другие названия, описание, вкус
GRAPES = [
    ("feteasca-neagra", "Fetească Neagră", "red", True, [], {
        "ru": "Древний местный красный сорт, один из символов молдавского виноделия. Даёт насыщенные вина, которые хорошо раскрываются с выдержкой.",
        "ro": "Soi roșu autohton străvechi, unul dintre simbolurile vinificației moldovenești. Dă vinuri intense, care se dezvoltă frumos la învechire.",
        "en": "An ancient native red grape and one of the symbols of Moldovan winemaking. It gives rich wines that develop beautifully with age."}, {
        "ru": "Чернослив, спелая вишня, чёрная смородина, пряности.",
        "ro": "Prune uscate, cireșe coapte, coacăză neagră, condimente.",
        "en": "Prunes, ripe cherry, blackcurrant, spice."}),
    ("rara-neagra", "Rară Neagră", "red", True, ["Băbească Neagră"], {
        "ru": "Местный красный сорт, в Румынии известный как Бэбяскэ Нягрэ. Даёт лёгкие, мягкие вина с яркой ягодностью.",
        "ro": "Soi roșu autohton, cunoscut în România ca Băbească Neagră. Dă vinuri ușoare, catifelate, cu fructuozitate vie.",
        "en": "A native red grape known in Romania as Băbească Neagră. It makes light, soft wines with bright red fruit."}, {
        "ru": "Вишня, красные ягоды, лёгкие пряные ноты.",
        "ro": "Vișine, fructe roșii, note ușor condimentate.",
        "en": "Sour cherry, red berries, a hint of spice."}),
    ("feteasca-alba", "Fetească Albă", "white", True, [], {
        "ru": "Старинный местный белый сорт. Вина получаются лёгкими и изящными, часто с тонким цветочным ароматом.",
        "ro": "Soi alb autohton vechi. Dă vinuri ușoare și elegante, adesea cu o aromă florală delicată.",
        "en": "An old native white grape producing light, elegant wines, often with a delicate floral aroma."}, {
        "ru": "Белые цветы, зелёное яблоко, персик.",
        "ro": "Flori albe, măr verde, piersică.",
        "en": "White flowers, green apple, peach."}),
    ("feteasca-regala", "Fetească Regală", "white", True, [], {
        "ru": "Белый сорт, появившийся в XX веке как потомок Фетяски Албэ. Свежий и универсальный — от сухих вин до игристых.",
        "ro": "Soi alb apărut în secolul XX, descendent al Feteascăi Albe. Proaspăt și versatil — de la vinuri seci la spumante.",
        "en": "A white grape that appeared in the 20th century as a descendant of Fetească Albă. Fresh and versatile — from dry wines to sparkling."}, {
        "ru": "Цитрусы, груша, свежескошенная трава.",
        "ro": "Citrice, pară, iarbă proaspăt cosită.",
        "en": "Citrus, pear, freshly cut grass."}),
    ("viorica", "Viorica", "white", True, [], {
        "ru": "Ароматный белый сорт, выведенный в Молдове во второй половине XX века. Узнаётся по яркому мускатному аромату.",
        "ro": "Soi alb aromat, creat în Moldova în a doua jumătate a secolului XX. Se recunoaște după aroma intensă de muscat.",
        "en": "An aromatic white grape bred in Moldova in the second half of the 20th century, recognisable by its vivid muscat aroma."}, {
        "ru": "Мускат, липа, цитрусы, тропические фрукты.",
        "ro": "Muscat, tei, citrice, fructe tropicale.",
        "en": "Muscat, linden blossom, citrus, tropical fruit."}),
    ("cabernet-sauvignon", "Cabernet Sauvignon", "red", False, [], {
        "ru": "Самый известный красный сорт в мире и один из самых распространённых в Молдове. Плотные, танинные вина для выдержки.",
        "ro": "Cel mai cunoscut soi roșu din lume și unul dintre cele mai răspândite în Moldova. Vinuri dense, taninoase, potrivite pentru învechire.",
        "en": "The world's best-known red grape and one of the most planted in Moldova. Full, tannic wines built for ageing."}, {
        "ru": "Чёрная смородина, вишня, табак, кедр.",
        "ro": "Coacăză neagră, cireșe, tutun, cedru.",
        "en": "Blackcurrant, cherry, tobacco, cedar."}),
    ("merlot", "Merlot", "red", False, [], {
        "ru": "Мягкий и бархатистый красный сорт, часто встречается в купажах с Каберне.",
        "ro": "Soi roșu moale și catifelat, des întâlnit în cupaje cu Cabernet.",
        "en": "A soft, velvety red grape, often blended with Cabernet."}, {
        "ru": "Слива, вишня, шоколад.",
        "ro": "Prune, cireșe, ciocolată.",
        "en": "Plum, cherry, chocolate."}),
    ("pinot-noir", "Pinot Noir", "red", False, [], {
        "ru": "Капризный, но изысканный красный сорт. Даёт лёгкие элегантные вина и служит основой многих игристых.",
        "ro": "Soi roșu pretențios, dar rafinat. Dă vinuri ușoare și elegante și stă la baza multor spumante.",
        "en": "A demanding but refined red grape, giving light, elegant wines and forming the base of many sparkling wines."}, {
        "ru": "Клубника, малина, вишня, лесные ноты.",
        "ro": "Căpșuni, zmeură, cireșe, note de pădure.",
        "en": "Strawberry, raspberry, cherry, forest floor."}),
    ("chardonnay", "Chardonnay", "white", False, [], {
        "ru": "Один из самых популярных белых сортов в мире. Бывает и свежим, и насыщенным после выдержки в дубе; основа классических игристых.",
        "ro": "Unul dintre cele mai populare soiuri albe din lume. Poate fi proaspăt sau bogat după învechire în stejar; bază pentru spumantele clasice.",
        "en": "One of the world's most popular white grapes — fresh or rich after oak ageing, and a base for classic sparkling wines."}, {
        "ru": "Яблоко, груша, цитрусы, ваниль (после дуба).",
        "ro": "Măr, pară, citrice, vanilie (după stejar).",
        "en": "Apple, pear, citrus, vanilla (when oaked)."}),
    ("sauvignon-blanc", "Sauvignon Blanc", "white", False, [], {
        "ru": "Свежий ароматный белый сорт с яркой кислотностью.",
        "ro": "Soi alb proaspăt și aromat, cu aciditate vie.",
        "en": "A fresh, aromatic white grape with lively acidity."}, {
        "ru": "Крыжовник, лайм, зелёный перец, трава.",
        "ro": "Agrișe, lime, ardei verde, iarbă.",
        "en": "Gooseberry, lime, green pepper, grass."}),
    # --- Добавлены после импорта вин от агента (сентябрь 2026) ---
    ("floricica", "Floricica", "white", True, [], {
        "ru": "Белый сорт молдавской селекции, устойчивый к морозам и болезням винограда. Из него делают свежие ароматные вина.",
        "ro": "Soi alb de selecție moldovenească, rezistent la ger și la bolile viței-de-vie. Din el se fac vinuri proaspete și aromate.",
        "en": "A white grape bred in Moldova, resistant to frost and vine diseases. It makes fresh, aromatic wines."}, {
        "ru": "Белые цветы, цитрусы, лёгкие мускатные ноты.",
        "ro": "Flori albe, citrice, note ușoare de muscat.",
        "en": "White flowers, citrus, a light muscat touch."}),
    ("codrinschi", "Codrinschi", "red", True, ["Codrinschii", "Codrinski"], {
        "ru": "Красный сорт молдавской селекции, названный в честь лесов Кодр. Устойчив к морозам, даёт вина глубокого цвета.",
        "ro": "Soi roșu de selecție moldovenească, numit după codrii Moldovei. Rezistent la ger, dă vinuri de culoare intensă.",
        "en": "A red grape bred in Moldova and named after the Codru forests. Frost-hardy, it gives deeply coloured wines."}, {
        "ru": "Тёмные ягоды, вишня, лёгкая пряность.",
        "ro": "Fructe de pădure negre, vișine, o notă ușor condimentată.",
        "en": "Dark berries, cherry, a light spice."}),
    ("alb-de-onitcani", "Alb de Onițcani", "white", True, ["Alb de Onitcani"], {
        "ru": "Белый сорт молдавской селекции. Встречается редко — в основном у небольших виноделен.",
        "ro": "Soi alb de selecție moldovenească. Se întâlnește rar — mai ales la vinăriile mici.",
        "en": "A white grape bred in Moldova. It is rare and found mostly at small wineries."}, {
        "ru": "Свежие фрукты, цветы, живая кислотность.",
        "ro": "Fructe proaspete, flori, aciditate vie.",
        "en": "Fresh fruit, flowers, lively acidity."}),
    ("tamaioasa-romaneasca", "Tămâioasă Românească", "white", True, ["Tamaioasa Romaneasca", "Tămâioasă"], {
        "ru": "Старинный ароматный белый сорт региона, родственник Муската. Известен ярким, почти «ладанным» ароматом.",
        "ro": "Soi alb aromat vechi al regiunii, rudă cu Muscatul. Cunoscut pentru aroma intensă, aproape de tămâie.",
        "en": "An old aromatic white grape of the region, related to Muscat, known for its intense, almost incense-like aroma."}, {
        "ru": "Мускат, роза, мёд, базилик.",
        "ro": "Muscat, trandafir, miere, busuioc.",
        "en": "Muscat, rose, honey, basil."}),
    ("saperavi", "Saperavi", "red", False, [], {
        "ru": "Грузинский сорт с окрашенной мякотью, широко распространённый в Молдове. Даёт очень тёмные, насыщенные вина с хорошей кислотностью.",
        "ro": "Soi georgian cu pulpă colorată, larg răspândit în Moldova. Dă vinuri foarte închise la culoare, intense, cu aciditate bună.",
        "en": "A Georgian grape with coloured flesh, widely planted in Moldova. It gives very dark, intense wines with good acidity."}, {
        "ru": "Ежевика, чернослив, тёмная вишня, специи.",
        "ro": "Mure, prune uscate, cireșe negre, condimente.",
        "en": "Blackberry, prune, dark cherry, spice."}),
    ("aligote", "Aligoté", "white", False, ["Aligote"], {
        "ru": "Белый сорт из Бургундии, давно и широко выращивается в Молдове. Лёгкие, свежие вина с яркой кислотностью.",
        "ro": "Soi alb din Burgundia, cultivat de mult și pe scară largă în Moldova. Vinuri ușoare și proaspete, cu aciditate vie.",
        "en": "A white grape from Burgundy, long and widely grown in Moldova. Light, fresh wines with bright acidity."}, {
        "ru": "Зелёное яблоко, лимон, полевые цветы.",
        "ro": "Măr verde, lămâie, flori de câmp.",
        "en": "Green apple, lemon, meadow flowers."}),
    ("riesling", "Riesling", "white", False, ["Rhine Riesling", "Riesling de Rin"], {
        "ru": "Благородный белый сорт из Германии: от сухих до сладких вин, с высокой кислотностью и хорошим потенциалом выдержки.",
        "ro": "Soi alb nobil din Germania: de la vinuri seci la dulci, cu aciditate ridicată și bun potențial de învechire.",
        "en": "A noble white grape from Germany, from dry to sweet styles, with high acidity and good ageing potential."}, {
        "ru": "Лайм, зелёное яблоко, персик, минеральность.",
        "ro": "Lime, măr verde, piersică, mineralitate.",
        "en": "Lime, green apple, peach, minerality."}),
    ("pinot-blanc", "Pinot Blanc", "white", False, ["Pinot Bianco", "Pinot Alb"], {
        "ru": "Белая разновидность Пино: мягкие, округлые вина с умеренной кислотностью, часто используется для игристых.",
        "ro": "Varietatea albă a Pinot-ului: vinuri moi, rotunde, cu aciditate moderată, des folosită pentru spumante.",
        "en": "The white member of the Pinot family: soft, round wines with moderate acidity, often used for sparkling wine."}, {
        "ru": "Груша, яблоко, миндаль.",
        "ro": "Pară, măr, migdale.",
        "en": "Pear, apple, almond."}),
    ("pinot-gris", "Pinot Gris", "white", False, ["Pinot Grigio"], {
        "ru": "Сорт с розовато-серой кожицей. В лёгком стиле известен как Пино Гриджо, в насыщенном — как Пино Гри.",
        "ro": "Soi cu pielița roz-cenușie. În stil ușor e cunoscut ca Pinot Grigio, în stil bogat — ca Pinot Gris.",
        "en": "A grape with pinkish-grey skin, known as Pinot Grigio in its light style and Pinot Gris in its richer style."}, {
        "ru": "Груша, дыня, цитрусы, лёгкая пряность.",
        "ro": "Pară, pepene galben, citrice, o notă ușor condimentată.",
        "en": "Pear, melon, citrus, a light spice."}),
    ("syrah", "Syrah", "red", False, ["Shiraz"], {
        "ru": "Красный сорт из долины Роны (он же Шираз): плотные вина с тёмными ягодами и перечными нотами.",
        "ro": "Soi roșu din valea Ronului (numit și Shiraz): vinuri dense, cu fructe negre și note de piper.",
        "en": "A red grape from the Rhône valley (also called Shiraz): full wines with dark fruit and peppery notes."}, {
        "ru": "Ежевика, слива, чёрный перец, копчёности.",
        "ro": "Mure, prune, piper negru, note afumate.",
        "en": "Blackberry, plum, black pepper, smoky notes."}),
    ("malbec", "Malbec", "red", False, ["Côt"], {
        "ru": "Красный сорт французского происхождения, прославленный Аргентиной: сочные, тёмные, мягкие вина.",
        "ro": "Soi roșu de origine franceză, devenit celebru în Argentina: vinuri suculente, închise și catifelate.",
        "en": "A red grape of French origin made famous by Argentina: juicy, dark, smooth wines."}, {
        "ru": "Слива, ежевика, какао, фиалка.",
        "ro": "Prune, mure, cacao, violete.",
        "en": "Plum, blackberry, cocoa, violet."}),
    ("tempranillo", "Tempranillo", "red", False, [], {
        "ru": "Главный красный сорт Испании (Риоха): вина средней насыщенности, хорошо сочетающиеся с выдержкой в дубе.",
        "ro": "Principalul soi roșu al Spaniei (Rioja): vinuri de corpolență medie, care se potrivesc bine cu învechirea în stejar.",
        "en": "Spain's leading red grape (Rioja): medium-bodied wines that take well to oak ageing."}, {
        "ru": "Вишня, томлёная слива, кожа, ваниль.",
        "ro": "Vișine, prune coapte, piele, vanilie.",
        "en": "Cherry, stewed plum, leather, vanilla."}),
    ("albarino", "Albariño", "white", False, ["Albarino", "Alvarinho"], {
        "ru": "Белый сорт с атлантического побережья Испании и Португалии: свежие ароматные вина, отлично подходящие к морепродуктам.",
        "ro": "Soi alb de pe coasta atlantică a Spaniei și Portugaliei: vinuri proaspete și aromate, excelente cu fructe de mare.",
        "en": "A white grape from the Atlantic coast of Spain and Portugal: fresh, aromatic wines that are great with seafood."}, {
        "ru": "Персик, абрикос, цитрусы, солёная свежесть.",
        "ro": "Piersică, caisă, citrice, prospețime sărată.",
        "en": "Peach, apricot, citrus, saline freshness."}),
    ("glera", "Glera", "white", False, ["Prosecco"], {
        "ru": "Итальянский белый сорт, из которого делают Просекко: лёгкие, фруктовые игристые вина.",
        "ro": "Soi alb italian din care se face Prosecco: vinuri spumante ușoare și fructuoase.",
        "en": "The Italian white grape behind Prosecco: light, fruity sparkling wines."}, {
        "ru": "Зелёное яблоко, груша, белые цветы.",
        "ro": "Măr verde, pară, flori albe.",
        "en": "Green apple, pear, white flowers."}),
    ("bastardo", "Bastardo", "red", False, ["Bastardo Magaraci", "Trousseau"], {
        "ru": "Красный сорт португальского происхождения (во Франции — Труссо). В нашем регионе известен по сорту Бастардо Магарачский.",
        "ro": "Soi roșu de origine portugheză (în Franța — Trousseau). În regiunea noastră este cunoscut prin soiul Bastardo Magaraci.",
        "en": "A red grape of Portuguese origin (Trousseau in France), known in our region through the Bastardo Magaraci variety."}, {
        "ru": "Красные ягоды, вишня, лёгкие землистые ноты.",
        "ro": "Fructe roșii, vișine, note ușor teroase.",
        "en": "Red berries, cherry, light earthy notes."}),
]


def sql_text_array(items):
    return "array[" + ", ".join(sql_str(a) for a in items) + "]::text[]" if items else "'{}'::text[]"


def grape_sql_rows():
    rows = []
    for n, (gid, name, color, native, aliases, desc, taste) in enumerate(GRAPES):
        rows.append(f"  ({sql_str(gid)}, {sql_str(name)}, {sql_str(color)}, {'true' if native else 'false'}, "
                    f"{sql_text_array(aliases)},\n   {sql_json(desc)},\n   {sql_json(taste)}, {(n + 1) * 10})")
    return rows


def dart_map(d):
    return "{" + ", ".join(f"{dart_str(k)}: {dart_str(v)}" for k, v in d.items()) + "}"


def sql_json(d):
    return "jsonb_build_object(" + ", ".join(f"{sql_str(k)}, {sql_str(v)}" for k, v in d.items()) + ")"

# id, winery_id, name, type, grape, vintage, rating, price, image, {ru, ro, en}
WINES = [
    (1, 1, "Fetească Neagră Premium", "red_dry", "Fetească Neagră", 2020, 4.8, 180, IMG_RED, {
        "ru": "Богатый аромат спелой вишни, чернослива и сафьяновой кожи.",
        "ro": "Arome bogate de cireșe coapte, prune uscate și piele fină.",
        "en": "Rich aromas of ripe cherry, prunes and fine leather."}),
    (2, 2, "Viorica de Purcari", "white_dry", "Viorica", 2023, 4.9, 145, IMG_WHITE, {
        "ru": "Свежий вкус с нотами муската, цитрусовых и белых цветов.",
        "ro": "Gust proaspăt cu note de muscat, citrice și flori albe.",
        "en": "Fresh taste with notes of muscat, citrus and white flowers."}),
    (3, 1, "Rară Neagră Taraboste", "red_dry", "Rară Neagră", 2019, 4.7, 320, IMG_AGED, {
        "ru": "Выдержанное вино с оттенками сухофруктов и дуба.",
        "ro": "Vin maturat cu nuanțe de fructe uscate și stejar.",
        "en": "An aged wine with hints of dried fruit and oak."}),
    (4, 3, "Cricova Brut", "sparkling", "Chardonnay, Pinot Noir", 2021, 4.6, 210, IMG_WHITE, {
        "ru": "Классическое игристое с тонкой перлажью, нотами яблока и бриоши.",
        "ro": "Spumant clasic cu perlaj fin, note de măr și brioșă.",
        "en": "A classic sparkling wine with fine bubbles and notes of apple and brioche."}),
    (5, 5, "Rosé de Mimi", "rose_dry", "Pinot Noir", 2023, 4.5, 190, IMG_WHITE, {
        "ru": "Лёгкое розовое с ароматом клубники, малины и цветов.",
        "ro": "Rose ușor cu arome de căpșuni, zmeură și flori.",
        "en": "A light rosé with aromas of strawberry, raspberry and flowers."}),
    (6, 6, "Asconi Sauvignon Blanc", "white_dry", "Sauvignon Blanc", 2023, 4.4, 130, IMG_WHITE, {
        "ru": "Хрустящее белое с нотами крыжовника, лайма и свежей травы.",
        "ro": "Alb crocant cu note de agrișe, lime și iarbă proaspătă.",
        "en": "A crisp white with notes of gooseberry, lime and fresh grass."}),
    (7, 7, "Et Cetera Merlot", "red_dry", "Merlot", 2020, 4.6, 250, IMG_RED, {
        "ru": "Мягкое бархатистое красное со спелой сливой и шоколадом.",
        "ro": "Roșu moale și catifelat, cu prune coapte și ciocolată.",
        "en": "A soft, velvety red with ripe plum and chocolate."}),
    (8, 4, "Mileștii Mici Cabernet Sauvignon", "red_dry", "Cabernet Sauvignon", 2018, 4.7, 280, IMG_AGED, {
        "ru": "Выдержанное в подвалах вино с тонами чёрной смородины и табака.",
        "ro": "Vin maturat în beciuri, cu tonuri de coacăză neagră și tutun.",
        "en": "Aged in underground cellars, with tones of blackcurrant and tobacco."}),
]


def dart_str(s):
    return "'" + s.replace("\\", "\\\\").replace("'", "\\'").replace("$", "\\$") + "'"


def sql_str(s):
    return "'" + s.replace("'", "''") + "'"


# ---------- Dart ----------
out = ["// Сгенерировано скриптом tool/gen_catalog_data.py (вместе с supabase/seed.sql).",
       "// Не правьте вручную — меняйте скрипт и запускайте заново.",
       "// Используется, пока Supabase не настроен (и в тестах).",
       "import '../models/grape.dart';",
       "import '../models/wine.dart';",
       "import '../models/winery.dart';",
       "",
       "final List<Wine> mockWines = ["]
for i, wid, name, typ, grape, vintage, rating, price, img, desc in WINES:
    d = ", ".join(f"{dart_str(k)}: {dart_str(v)}" for k, v in desc.items())
    out.append(f"""  Wine(
    id: '{i}',
    name: {dart_str(name)},
    wineryId: '{wid}',
    wineryName: {dart_str(WINERY_NAME[wid])},
    type: '{typ}',
    grapeVariety: {dart_str(grape)},
    vintage: {vintage},
    rating: {rating},
    priceLei: {price},
    imageUrl: {dart_str(img)},
    description: {{{d}}},
  ),""")
out += ["];", "", "// Координаты примерные — уточните перед релизом", "const List<Winery> mockWineries = ["]
for i, name, lat, lng, region in WINERIES:
    det = WINERY_DETAILS.get(i, {})
    founded = f"\n    foundedYear: {det['founded']}," if det.get("founded") else ""
    out.append(f"""  Winery(
    id: {i},
    name: {dart_str(name)},
    latitude: {lat},
    longitude: {lng},
    region: {dart_str(region)},
    description: {dart_map(det.get("description", {}))},{founded}
  ),""")
out += ["];", "", "const List<Grape> mockGrapes = ["]
for gid, name, color, native, aliases, desc, taste in GRAPES:
    al = ", ".join(dart_str(a) for a in aliases)
    out.append(f"""  Grape(
    id: '{gid}',
    name: {dart_str(name)},
    color: '{color}',
    isNative: {'true' if native else 'false'},
    aliases: [{al}],
    description: {dart_map(desc)},
    taste: {dart_map(taste)},
  ),""")
out += ["];", ""]
open(ROOT + "lib/data/mock_data.dart", "w", encoding="utf-8", newline="\n").write("\n".join(out))

# ---------- SQL ----------
os.makedirs(ROOT + "supabase", exist_ok=True)
sql = ["-- Начальные данные. Выполняется после миграции (или автоматически через `supabase db reset`).",
       "-- Сгенерировано скриптом tool/gen_catalog_data.py (вместе с lib/data/mock_data.dart).",
       "",
       "insert into public.wineries (id, name, latitude, longitude, region, founded_year, description) values"]
sql.append(",\n".join(
    f"  ({i}, {sql_str(n)}, {lat}, {lng}, {sql_str(r)}, {WINERY_DETAILS.get(i, {}).get('founded') or 'null'},\n   {sql_json(WINERY_DETAILS.get(i, {}).get('description', {}))})"
    for i, n, lat, lng, r in WINERIES) + "\non conflict (id) do nothing;")
sql += ["", "insert into public.wines (id, winery_id, name, type, grape_variety, vintage, rating, avg_price_lei, image_url, description) values"]
rows = []
for i, wid, name, typ, grape, vintage, rating, price, img, desc in WINES:
    j = "jsonb_build_object(" + ", ".join(f"{sql_str(k)}, {sql_str(v)}" for k, v in desc.items()) + ")"
    rows.append(f"  ({i}, {wid}, {sql_str(name)}, {sql_str(typ)}, {sql_str(grape)}, {vintage}, {rating}, {price}, {sql_str(img)},\n   {j})")
sql.append(",\n".join(rows) + "\non conflict (id) do nothing;")
sql += ["", "insert into public.grapes (id, name, color, is_native, aliases, description, taste, sort_order) values"]
sql.append(",\n".join(grape_sql_rows()) + "\non conflict (id) do nothing;")
sql += ["",
        "-- id заданы вручную — сдвигаем счётчики, чтобы новые записи не конфликтовали",
        "select setval(pg_get_serial_sequence('public.wineries', 'id'), (select max(id) from public.wineries));",
        "select setval(pg_get_serial_sequence('public.wines', 'id'), (select max(id) from public.wines));",
        ""]
open(ROOT + "supabase/seed.sql", "w", encoding="utf-8", newline="\n").write("\n".join(sql))

if len(sys.argv) > 1:
    # python tool/gen_catalog_data.py <файл> — SQL для обновления описаний в уже заполненной базе
    upd = ["-- Описания и год основания виноделен (для базы, заполненной раньше)."]
    for i, *_ in WINERIES:
        det = WINERY_DETAILS.get(i, {})
        upd.append(f"update public.wineries set description = {sql_json(det.get('description', {}))}, "
                   f"founded_year = {det.get('founded') or 'null'} where id = {i};")
    upd += ["", "-- Справочник сортов",
            "insert into public.grapes (id, name, color, is_native, aliases, description, taste, sort_order) values",
            ",\n".join(grape_sql_rows()) + "\non conflict (id) do nothing;"]
    open(sys.argv[1], "w", encoding="utf-8", newline="\n").write("\n".join(upd) + "\n")
print("ok")
