"""Скриншоты для Google Play: подпись сверху + экран телефона, 1080×1920.

Google Play не принимает изображения, где длинная сторона больше короткой
в 2 раза, а экран телефона (1080×2400) длиннее — поэтому «рамка».

Запуск: python tool/make_store_screenshots.py <папка_с_сырыми_скринами> [en|ro|ru]
Сырые скрины (adb exec-out screencap -p > 01_catalog.png) называются
01_catalog.png, 02_wine.png, 03_map.png, 04_pairing.png, 05_grapes.png, 06_cellar.png.
"""
import os
import sys

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
W, H = 1080, 1920
WINE_DARK = (0x3E, 0x0A, 0x12)
WINE = (0x6E, 0x16, 0x24)
GOLD = (0xE6, 0xC7, 0x6A)
FONT_BOLD = "C:/Windows/Fonts/segoeuib.ttf"
FONT = "C:/Windows/Fonts/segoeui.ttf"

CAPTIONS = {
    "en": {
        "01_catalog": ("Explore Moldovan wines", "Search, filter and sort the catalog"),
        "02_wine": ("Everything about each wine", "Taste, food pairing and your notes"),
        "03_map": ("Wineries on the map", "Visiting info and directions in one tap"),
        "04_pairing": ("The right wine for your dish", "Plăcinte, tochitură, zeamă and more"),
        "05_grapes": ("Native grape guide", "Fetească Neagră, Rară Neagră, Viorica…"),
        "06_cellar": ("Your personal cellar", "Save wines, rate them, write notes"),
    },
    "ro": {
        "01_catalog": ("Descoperă vinurile Moldovei", "Caută, filtrează și sortează catalogul"),
        "02_wine": ("Totul despre fiecare vin", "Gust, asocieri și notițele tale"),
        "03_map": ("Vinăriile pe hartă", "Informații de vizită și traseu dintr-o atingere"),
        "04_pairing": ("Vinul potrivit pentru masă", "Plăcinte, tochitură, zeamă și altele"),
        "05_grapes": ("Ghidul soiurilor autohtone", "Fetească Neagră, Rară Neagră, Viorica…"),
        "06_cellar": ("Crama ta personală", "Salvează vinuri, dă note, scrie impresii"),
    },
    "ru": {
        "01_catalog": ("Откройте вина Молдовы", "Поиск, фильтры и сортировка каталога"),
        "02_wine": ("Всё о каждом вине", "Вкус, гастро-пара и ваши заметки"),
        "03_map": ("Винодельни на карте", "Информация для визита и маршрут в одно касание"),
        "04_pairing": ("Вино к вашему блюду", "Плацинды, токана, зама и не только"),
        "05_grapes": ("Справочник местных сортов", "Фетяска Нягрэ, Рарэ Нягрэ, Виорика…"),
        "06_cellar": ("Ваш личный подвал", "Сохраняйте вина, ставьте оценки, пишите заметки"),
    },
}


def background():
    bg = Image.new("RGB", (W, H), WINE_DARK)
    top = Image.new("RGB", (W, H), WINE)
    mask = Image.linear_gradient("L").resize((W, H)).point(lambda v: 255 - v)
    bg.paste(top, (0, 0), mask)
    return bg


def rounded(im, radius):
    mask = Image.new("L", im.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, *im.size], radius, fill=255)
    out = Image.new("RGBA", im.size)
    out.paste(im, (0, 0), mask)
    return out


def centered(draw, y, text, font, fill):
    w = draw.textlength(text, font=font)
    draw.text(((W - w) / 2, y), text, font=font, fill=fill)


def compose(raw_path, title, subtitle):
    canvas = background().convert("RGBA")
    draw = ImageDraw.Draw(canvas)
    centered(draw, 110, title, ImageFont.truetype(FONT_BOLD, 66), (255, 255, 255))
    centered(draw, 205, subtitle, ImageFont.truetype(FONT, 38), GOLD)

    phone_h = 1440
    shot = Image.open(raw_path).convert("RGB")
    shot = shot.resize((round(shot.width * phone_h / shot.height), phone_h), Image.LANCZOS)
    x, y = (W - shot.width) // 2, 400

    # Мягкая тень под «телефоном»
    shadow = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle(
        [x - 6, y + 14, x + shot.width + 6, y + phone_h + 22], 52, fill=(0, 0, 0, 140))
    canvas.alpha_composite(shadow.filter(ImageFilter.GaussianBlur(22)))
    # Тонкая «рамка» корпуса
    ImageDraw.Draw(canvas).rounded_rectangle(
        [x - 10, y - 10, x + shot.width + 10, y + phone_h + 10], 56, fill=(20, 4, 8, 255))
    canvas.alpha_composite(rounded(shot, 46), (x, y))
    return canvas.convert("RGB")


def main():
    raw_dir = sys.argv[1]
    lang = sys.argv[2] if len(sys.argv) > 2 else "en"
    out_dir = os.path.join(ROOT, "docs", "play-store", "screenshots", lang)
    os.makedirs(out_dir, exist_ok=True)
    for name, (title, subtitle) in CAPTIONS[lang].items():
        raw = os.path.join(raw_dir, name + ".png")
        if not os.path.exists(raw):
            continue
        compose(raw, title, subtitle).save(os.path.join(out_dir, name + ".png"), optimize=True)
        print("ok", lang, name)


if __name__ == "__main__":
    main()
