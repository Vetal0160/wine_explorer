import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../core/supabase_config.dart';

/// Бакет Supabase Storage с фото вин (см. supabase/migrations).
const _bucket = 'wine-images';

/// В image_url можно хранить полный адрес или путь к файлу в бакете
/// («purcari/viorica.jpg»). Путь превращается в публичную ссылку Storage.
String? resolveWineImageUrl(String imageUrl) {
  final value = imageUrl.trim();
  if (value.isEmpty) return null;
  if (value.startsWith('http://') || value.startsWith('https://')) {
    return value;
  }
  if (supabaseUrl.isEmpty) return null;
  final path = value.startsWith('/') ? value.substring(1) : value;
  return '$supabaseUrl/storage/v1/object/public/$_bucket/$path';
}

/// Фото вина; если фото нет или оно не загрузилось — заглушка в цвете вина.
class WineImage extends StatelessWidget {
  final String imageUrl;
  final String wineType;
  final double? width;
  final double? height;
  final double iconSize;

  /// Иконка на заглушке; по умолчанию — бокал (или хлопушка для игристого).
  final IconData? placeholderIcon;

  const WineImage({
    super.key,
    required this.imageUrl,
    required this.wineType,
    this.width,
    this.height,
    this.iconSize = 40,
    this.placeholderIcon,
  });

  @override
  Widget build(BuildContext context) {
    final url = resolveWineImageUrl(imageUrl);
    final placeholder = _WinePlaceholder(
      wineType: wineType,
      icon: placeholderIcon,
      width: width,
      height: height,
      iconSize: iconSize,
    );
    if (url == null) return placeholder;

    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      placeholder: (context, url) => placeholder,
      errorWidget: (context, url, error) => placeholder,
    );
  }
}

/// Градиент в цвете вина с иконкой бокала.
class _WinePlaceholder extends StatelessWidget {
  final String wineType;
  final double? width;
  final double? height;
  final double iconSize;
  final IconData? icon;

  const _WinePlaceholder({
    required this.wineType,
    this.icon,
    this.width,
    this.height,
    required this.iconSize,
  });

  static const _colors = {
    'red': [Color(0xFF8B263E), Color(0xFF3E0A12)],
    'white': [Color(0xFFF3E7B3), Color(0xFFC9B26A)],
    'rose': [Color(0xFFF7C6CF), Color(0xFFD9788C)],
    'sparkling': [Color(0xFFF5EFD9), Color(0xFFD4AF37)],
  };

  List<Color> get _gradient {
    for (final entry in _colors.entries) {
      if (wineType.startsWith(entry.key)) return entry.value;
    }
    return _colors['red']!;
  }

  @override
  Widget build(BuildContext context) {
    final colors = _gradient;
    final dark = colors.last.computeLuminance() < 0.3;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Icon(
        icon ?? (wineType == 'sparkling' ? Icons.celebration : Icons.wine_bar),
        size: iconSize,
        color: dark ? Colors.white70 : Colors.black45,
      ),
    );
  }
}
