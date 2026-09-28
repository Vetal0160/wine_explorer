import 'localized_text.dart';

/// Сорт винограда для справочника.
class Grape {
  const Grape({
    required this.id,
    required this.name,
    required this.color,
    this.isNative = false,
    this.aliases = const [],
    this.description = const {},
    this.taste = const {},
    this.imageUrl = '',
  });

  /// Код сорта, например «feteasca-neagra».
  final String id;
  final String name;

  /// 'red' или 'white'.
  final String color;

  /// Местный (автохтонный) молдавский сорт.
  final bool isNative;

  /// Другие названия, под которыми сорт встречается на этикетках.
  final List<String> aliases;
  final LocalizedText description;

  /// Типичные ароматы и вкус.
  final LocalizedText taste;
  final String imageUrl;

  bool get isRed => color == 'red';

  String descriptionFor(String languageCode) =>
      localizedFor(description, languageCode);

  String tasteFor(String languageCode) => localizedFor(taste, languageCode);

  /// Это название (с этикетки) относится к сорту — без учёта регистра и
  /// румынских диакритик: «Feteasca neagra» = «Fetească Neagră».
  bool matchesName(String value) {
    final v = normalizeGrapeName(value);
    return normalizeGrapeName(name) == v ||
        aliases.any((a) => normalizeGrapeName(a) == v);
  }

  factory Grape.fromJson(Map<String, dynamic> json) => Grape(
    id: json['id'] as String,
    name: json['name'] as String,
    color: json['color'] as String? ?? 'red',
    isNative: json['is_native'] as bool? ?? false,
    aliases:
        (json['aliases'] as List?)?.map((e) => e.toString()).toList() ??
        const [],
    description: parseLocalizedText(json['description']),
    taste: parseLocalizedText(json['taste']),
    imageUrl: json['image_url'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'color': color,
    'is_native': isNative,
    'aliases': aliases,
    'description': description,
    'taste': taste,
    'image_url': imageUrl,
  };
}

/// «Fetească Neagră » → «feteasca neagra».
String normalizeGrapeName(String value) {
  const map = {
    'ă': 'a', 'â': 'a', 'î': 'i', 'ș': 's', 'ş': 's', 'ț': 't', 'ţ': 't', //
    'é': 'e', 'è': 'e', 'ô': 'o',
  };
  final lower = value.trim().toLowerCase();
  final buffer = StringBuffer();
  for (final ch in lower.split('')) {
    buffer.write(map[ch] ?? ch);
  }
  return buffer.toString().replaceAll(RegExp(r'\s+'), ' ');
}

/// «Chardonnay, Pinot Noir» → ['Chardonnay', 'Pinot Noir'].
List<String> splitGrapeVarieties(String value) => value
    .split(RegExp(r'[,/&+;]'))
    .map((s) => s.trim())
    .where((s) => s.isNotEmpty)
    .toList();
