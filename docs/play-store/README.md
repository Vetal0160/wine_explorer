# Google Play: тексты и ответы для Play Console

Всё, что нужно вставить в Play Console. Перед отправкой проверьте, что ответы
по-прежнему правда: если в приложение добавятся вход, аналитика или реклама —
Data safety и политику конфиденциальности нужно обновить.

- **Политика конфиденциальности:** `https://vetal0160.github.io/wine_explorer/privacy-policy.html`
  (после включения GitHub Pages — см. ниже)
- **Сайт (необязательно):** `https://vetal0160.github.io/wine_explorer/`
- **Email для связи:** `wineexplorer.md@gmail.com` (уже в политике)

---

## 1. Карточка приложения (Main store listing)

Английский — основной язык, румынский и русский добавляются как переводы
(Store presence → Main store listing → Manage translations).

**Название (до 30 символов):** `Moldova Wine Explorer`

### English (en-US)

**Short description (≤ 80):**
Guide to Moldovan wines & wineries: map, food pairings, grapes and your cellar

**Full description:**

Discover the wines of Moldova — whether you live here or are visiting for a wine tour.

🍷 WINE CATALOG
Browse Moldovan wines with ratings, prices, grape varieties and tasting notes. Search by name, winery or grape, filter by wine type, price and winery, and sort the way you like.

🗺️ WINERY MAP
See Moldova’s wineries on a map, open a winery page with its story and visiting information, and get directions in one tap.

🍽️ FOOD PAIRINGS
Choose a dish — plăcinte, tochitură, zeamă, mămăligă, grilled meat, fish, cheese or dessert — and get wine suggestions with a short explanation why they match.

🌿 GRAPE GUIDE
Learn about native grapes such as Fetească Neagră, Rară Neagră, Fetească Albă and Viorica, and international varieties grown in Moldova.

❤️ MY CELLAR
Save wines you like, rate them and write your own tasting notes — where you bought it and what you paired it with.

📤 SHARE
Send a wine or a winery to friends in any messenger.

📶 WORKS OFFLINE
The last loaded catalog stays on your phone, so the app works even with a weak signal at the vineyard.

Available in English, Romanian and Russian. No account, no ads.

This app provides information only and does not sell alcohol. For adults 18+. Please drink responsibly.

### Română (ro)

**Descriere scurtă (≤ 80):**
Ghid al vinurilor din Moldova: vinării pe hartă, asocieri, soiuri și crama ta

**Descriere completă:**

Descoperă vinurile Moldovei — fie că locuiești aici, fie că ai venit într-un tur al vinului.

🍷 CATALOG DE VINURI
Vinuri moldovenești cu rating, prețuri, soiuri și note de degustare. Caută după nume, vinărie sau soi, filtrează după tip, preț și vinărie și sortează cum preferi.

🗺️ HARTA VINĂRIILOR
Vezi vinăriile Moldovei pe hartă, deschide pagina unei vinării cu istoria și informațiile pentru vizită și obține traseul dintr-o atingere.

🍽️ ASOCIERI CU MÂNCĂRURI
Alege un fel de mâncare — plăcinte, tochitură, zeamă, mămăligă, frigărui, pește, brânzeturi sau desert — și primește sugestii de vinuri cu o scurtă explicație.

🌿 GHIDUL SOIURILOR
Află despre soiurile autohtone precum Fetească Neagră, Rară Neagră, Fetească Albă și Viorica, dar și despre soiurile internaționale cultivate în Moldova.

❤️ CRAMA MEA
Salvează vinurile preferate, dă-le o notă și scrie-ți propriile impresii — unde l-ai cumpărat și cu ce l-ai asociat.

📤 DISTRIBUIE
Trimite un vin sau o vinărie prietenilor în orice messenger.

📶 FUNCȚIONEAZĂ FĂRĂ INTERNET
Ultimul catalog încărcat rămâne pe telefon, așa că aplicația merge chiar și cu semnal slab în podgorie.

Disponibilă în română, rusă și engleză. Fără cont, fără publicitate.

Aplicația oferă doar informații și nu vinde alcool. Pentru persoane de peste 18 ani. Consumați cu moderație.

### Русский (ru-RU)

**Краткое описание (≤ 80):**
Гид по винам Молдовы: винодельни на карте, гастро-пары, сорта и ваш подвал

**Полное описание:**

Откройте для себя вина Молдовы — живёте ли вы здесь или приехали в винный тур.

🍷 КАТАЛОГ ВИН
Молдавские вина с рейтингом, ценами, сортами и описанием вкуса. Поиск по названию, винодельне или сорту, фильтры по типу, цене и винодельне, удобная сортировка.

🗺️ КАРТА ВИНОДЕЛЕН
Винодельни Молдовы на карте, страница винодельни с историей и информацией для посещения и маршрут в одно касание.

🍽️ ГАСТРО-ПАРЫ
Выберите блюдо — плацинды, токану, заму, мамалыгу, шашлык, рыбу, сыры или десерт — и получите подходящие вина с объяснением, почему они сочетаются.

🌿 СПРАВОЧНИК СОРТОВ
Местные сорта — Фетяска Нягрэ, Рарэ Нягрэ, Фетяска Албэ, Виорика — и международные сорта, которые выращивают в Молдове.

❤️ МОЙ ПОДВАЛ
Сохраняйте понравившиеся вина, ставьте оценки и пишите свои заметки — где купили и с чем пили.

📤 ПОДЕЛИТЬСЯ
Отправьте вино или винодельню друзьям в любой мессенджер.

📶 РАБОТАЕТ БЕЗ ИНТЕРНЕТА
Последний загруженный каталог остаётся на телефоне — приложение работает даже при слабой связи на винодельне.

Доступно на русском, румынском и английском. Без регистрации и без рекламы.

Приложение носит информационный характер и не продаёт алкоголь. Для лиц старше 18 лет. Употребляйте ответственно.

### Графика
- **Иконка 512×512:** `assets/icon/icon.png` (1024×1024 — Play уменьшит; при необходимости сохраните копию 512×512)
- **Feature graphic 1024×500:** `docs/play-store/feature-graphic-en.png` (в переводах карточки — `-ro.png` и `-ru.png`; пересоздать: `python tool/make_feature_graphic.py`)
- **Скриншоты телефона:** `docs/play-store/screenshots/en/` (5 шт.; пересоздать: `python tool/make_store_screenshots.py <папка со скринами> en|ro|ru`)

---

## 2. App content (раздел «Содержимое приложения»)

| Раздел | Ответ |
|---|---|
| **Privacy policy** | ссылка на `privacy-policy.html` (см. выше) |
| **Ads** | No, my app does not contain ads |
| **App access** | All functionality is available without special access. Инструкция для проверки: *On first launch, tap “Yes, I'm 18+”.* |
| **Target audience** | Возраст **18 and over** (только эта группа) |
| **Content rating** | См. ниже |
| **Data safety** | См. ниже |
| **Government apps** | No |
| **Financial features** | None |
| **Health** | No health features |
| **News app** | No |

### Content rating (анкета IARC)
- Email для рейтинга — ваш контактный адрес
- Категория: **Reference, News, or Educational** (справочник) — или *All other app types*, если так ближе
- Violence, sexuality, language, gambling, controlled substances (наркотики) — **No**
- **References to alcohol / Depicts or references alcohol — Yes** (информация о вине, без призывов к злоупотреблению)
- Пользователи могут общаться / делиться контентом между собой внутри приложения — **No** (кнопка «Поделиться» открывает внешние приложения)
- Приложение продаёт цифровые товары — **No**
- Передаёт местоположение пользователя — **No**

### Data safety
- **Does your app collect or share any of the required user data types?** → **No**
  - Заметки, подвал, язык и подтверждение возраста хранятся только на устройстве — это не считается «сбором».
  - Приложение не запрашивает местоположение, контакты, фото, аккаунты.
- **Is all of the user data collected by your app encrypted in transit?** → Yes (все запросы идут по HTTPS)
- **Do you provide a way for users to request that their data be deleted?** → данных на сервере нет; локальные данные удаляются очисткой данных приложения или удалением приложения

> ⚠️ Если позже появятся вход, аналитика (Firebase/Sentry), реклама или GPS «рядом со мной» —
> ответы изменятся. Обновите Data safety **до** выпуска такой версии.

---

## 3. Категория и контакты (Store settings)
- **App or game:** App
- **Category:** Food & Drink (альтернатива — Travel & Local)
- **Tags:** Wine, Travel guide, Food & drink
- **Contact email:** ваш контактный адрес
- **Website:** `https://vetal0160.github.io/wine_explorer/` (необязательно)

---

## 4. Включить GitHub Pages (публикация политики)
1. github.com/Vetal0160/wine_explorer → **Settings → Pages**
2. **Source:** Deploy from a branch · **Branch:** `main` · папка **`/docs`** → Save
3. Через 1–2 минуты страница откроется по адресу
   `https://vetal0160.github.io/wine_explorer/privacy-policy.html`

---

## 5. Закрытый тест
1. **Testing → Closed testing → Create track**
2. **Testers:** список email (или Google Group) — для новых личных аккаунтов нужно **не меньше 12 тестировщиков**, которые участвуют **14 дней подряд** (проверьте актуальные требования в Play Console)
3. **Create release** → загрузите `build/app/outputs/bundle/release/app-release.aab`
   (собирать: `flutter build appbundle --release --dart-define-from-file=supabase.json`, после создания `android/key.properties`)
4. **Play App Signing:** соглашайтесь — Google хранит ключ приложения, ваш `.jks` становится ключом загрузки
5. Отправьте ссылку-приглашение тестировщикам; после 14 дней — **Apply for production**
