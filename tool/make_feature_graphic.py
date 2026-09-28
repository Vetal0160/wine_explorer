"""Баннер для Google Play (feature graphic) 1024×500 на en/ro/ru.

Запуск: python tool/make_feature_graphic.py (нужен Pillow и assets/icon/splash.png)
Результат: docs/play-store/feature-graphic-<язык>.png
"""
import math
import os

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
W, H = 1024, 500
SCALE = 2  # рисуем вдвое крупнее и уменьшаем — сглаженные края
WINE_DARK = (0x3A, 0x09, 0x10)
WINE = (0x6E, 0x16, 0x24)
GOLD = (0xD4, 0xAF, 0x37)
GOLD_LIGHT = (0xF1, 0xD7, 0x7A)
TITLE_FONT = "C:/Windows/Fonts/georgiab.ttf"   # только латиница — название одинаковое на всех языках
TEXT_FONT = "C:/Windows/Fonts/segoeui.ttf"     # есть ș ț и кириллица

TAGLINES = {
    "en": "Wines · Wineries · Grapes of Moldova",
    "ro": "Vinuri · Vinării · Soiuri din Moldova",
    "ru": "Вина · Винодельни · Сорта Молдовы",
}


def background():
    w, h = W * SCALE, H * SCALE
    bg = Image.new("RGB", (w, h), WINE_DARK)
    # Свечение слева, за бокалом
    glow = Image.new("L", (w, h), 0)
    ImageDraw.Draw(glow).ellipse([-w * 0.15, -h * 0.35, w * 0.6, h * 1.25], fill=255)
    glow = glow.filter(ImageFilter.GaussianBlur(w * 0.08))
    bg.paste(Image.new("RGB", (w, h), WINE), (0, 0), glow)

    # Холмы с виноградниками внизу: три слоя, каждый темнее
    d = ImageDraw.Draw(bg, "RGBA")
    layers = [
        (0.80, 0.045, 2.2, 0.0, (0x4A, 0x0D, 0x16, 255)),
        (0.86, 0.035, 3.1, 1.3, (0x34, 0x08, 0x0E, 255)),
        (0.92, 0.030, 4.0, 2.6, (0x26, 0x05, 0x0A, 255)),
    ]
    for base, amp, freq, phase, color in layers:
        pts = [(0, h)]
        for x in range(0, w + 1, 8):
            y = h * (base - amp * math.sin(freq * math.pi * x / w + phase))
            pts.append((x, y))
        pts.append((w, h))
        d.polygon(pts, fill=color)
        # Ряды лоз — короткие штрихи вдоль склона
        for x in range(20, w, 34):
            y = h * (base - amp * math.sin(freq * math.pi * x / w + phase))
            d.line([(x, y + 14), (x + 10, y + 26)], fill=(255, 255, 255, 18), width=3)
    return bg


def banner(lang):
    img = background().convert("RGBA")
    w, h = img.size

    glass = Image.open(os.path.join(ROOT, "assets/icon/splash.png")).convert("RGBA")
    size = int(h * 0.78)
    glass = glass.resize((size, size), Image.LANCZOS)
    img.alpha_composite(glass, (int(w * 0.04), int(h * 0.05)))

    d = ImageDraw.Draw(img)
    x = int(w * 0.36)
    title_font = ImageFont.truetype(TITLE_FONT, 78 * SCALE)
    d.text((x, int(h * 0.26)), "Moldova", font=title_font, fill=(255, 255, 255))
    d.text((x, int(h * 0.26) + 88 * SCALE), "Wine Explorer", font=title_font, fill=GOLD_LIGHT)

    # Тонкая золотая линия и подзаголовок
    line_y = int(h * 0.26) + 190 * SCALE
    d.line([(x + 4, line_y), (x + 150 * SCALE, line_y)], fill=GOLD, width=3 * SCALE)
    d.text((x + 2, line_y + 16 * SCALE), TAGLINES[lang],
           font=ImageFont.truetype(TEXT_FONT, 30 * SCALE), fill=(255, 255, 255, 230))
    return img.convert("RGB").resize((W, H), Image.LANCZOS)


def main():
    out_dir = os.path.join(ROOT, "docs", "play-store")
    for lang in TAGLINES:
        path = os.path.join(out_dir, f"feature-graphic-{lang}.png")
        banner(lang).save(path, optimize=True)
        print("ok", path)


if __name__ == "__main__":
    main()
