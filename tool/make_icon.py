"""Иконка Wine Explorer: золотой бокал с вином на бордовом фоне.

Запуск: python tool/make_icon.py (нужен Pillow), затем
  dart run flutter_launcher_icons
  dart run flutter_native_splash:create
"""
import os
from PIL import Image, ImageDraw, ImageFilter

# Корень проекта — на уровень выше папки tool/
OUT = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "assets/icon/")
os.makedirs(OUT, exist_ok=True)

S = 4096  # рисуем крупно и уменьшаем — сглаженные края
WINE_DARK = (0x3E, 0x0A, 0x12)
WINE = (0x58, 0x11, 0x1A)
WINE_LIGHT = (0x8B, 0x26, 0x3E)
GOLD = (0xD4, 0xAF, 0x37)
GOLD_LIGHT = (0xF1, 0xD7, 0x7A)


def glass_layer(scale):
    """Бокал на прозрачном фоне; scale — доля высоты холста под бокал."""
    img = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    h = S * scale
    cx = S / 2
    top = (S - h) / 2
    bowl_r = h * 0.30          # полуширина чаши
    rim_y = top                 # край бокала
    bowl_bottom = top + h * 0.52
    stroke = h * 0.045

    # Чаша: нижняя часть эллипса, обрезанная по краю
    bowl = Image.new("L", (S, S), 0)
    bd = ImageDraw.Draw(bowl)
    bd.ellipse([cx - bowl_r, rim_y - (bowl_bottom - rim_y),
                cx + bowl_r, bowl_bottom], fill=255)
    bd.rectangle([0, 0, S, rim_y], fill=0)

    inner = Image.new("L", (S, S), 0)
    idr = ImageDraw.Draw(inner)
    idr.ellipse([cx - bowl_r + stroke, rim_y - (bowl_bottom - rim_y) + stroke,
                 cx + bowl_r - stroke, bowl_bottom - stroke], fill=255)
    idr.rectangle([0, 0, S, rim_y + stroke * 0.2], fill=0)

    # Вино — нижние ~55% чаши
    wine_level = rim_y + (bowl_bottom - rim_y) * 0.42
    wine = inner.copy()
    ImageDraw.Draw(wine).rectangle([0, 0, S, wine_level], fill=0)

    gold = Image.new("RGBA", (S, S), GOLD + (255,))
    img.paste(gold, (0, 0), bowl)
    # Внутри чаши — «стекло»: полупрозрачное, чтобы золото читалось как контур
    glass_fill = Image.new("RGBA", (S, S), (255, 255, 255, 38))
    img.paste((0, 0, 0, 0), (0, 0), inner)
    img.alpha_composite(Image.composite(glass_fill, Image.new("RGBA", (S, S)), inner))
    wine_fill = Image.new("RGBA", (S, S), (0xC0, 0x1F, 0x3E, 255))
    img.paste(wine_fill, (0, 0), wine)

    # Блик на чаше
    d.ellipse([cx - bowl_r * 0.62, wine_level + h * 0.03,
               cx - bowl_r * 0.42, wine_level + h * 0.16], fill=(255, 255, 255, 90))

    # Ножка и основание
    stem_w = h * 0.05
    stem_top = bowl_bottom - stroke
    base_y = top + h * 0.92
    d.rectangle([cx - stem_w / 2, stem_top, cx + stem_w / 2, base_y], fill=GOLD + (255,))
    base_w = h * 0.26
    base_h = h * 0.08
    d.ellipse([cx - base_w, base_y - base_h / 2, cx + base_w, base_y + base_h / 2],
              fill=GOLD + (255,))
    return img


def background():
    bg = Image.new("RGB", (S, S), WINE)
    # Мягкий радиальный градиент: светлее в центре
    glow = Image.new("L", (S, S), 0)
    ImageDraw.Draw(glow).ellipse([S * 0.1, S * 0.05, S * 0.9, S * 0.85], fill=255)
    glow = glow.filter(ImageFilter.GaussianBlur(S * 0.12))
    bg.paste(Image.new("RGB", (S, S), WINE_LIGHT), (0, 0), glow.point(lambda v: v * 0.55))
    edge = Image.new("L", (S, S), 255)
    ImageDraw.Draw(edge).ellipse([-S * 0.1, -S * 0.1, S * 1.1, S * 1.1], fill=0)
    edge = edge.filter(ImageFilter.GaussianBlur(S * 0.08))
    bg.paste(Image.new("RGB", (S, S), WINE_DARK), (0, 0), edge)
    return bg


def save(img, name, size=1024):
    img.resize((size, size), Image.LANCZOS).save(OUT + name)


# 1) Обычная иконка (iOS, старые Android, Google Play)
full = background().convert("RGBA")
full.alpha_composite(glass_layer(0.62))
save(full.convert("RGB"), "icon.png")

# 2) Adaptive icon (Android 8+): бокал в безопасной зоне ~60%, фон отдельно
save(glass_layer(0.46), "icon_foreground.png")
save(background(), "icon_background.png")

# 3) Заставка при запуске: только бокал
save(glass_layer(0.62), "splash.png", 768)
print("ok")
