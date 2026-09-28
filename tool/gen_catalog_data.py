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
    open(sys.argv[1], "w", encoding="utf-8", newline="\n").write("\n".join(upd) + "\n")
print("ok")
