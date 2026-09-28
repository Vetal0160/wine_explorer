import 'localized_text.dart';

class Wine {
  final String id;
  final String name;
  final String? wineryId;
  final String wineryName;
  final String type;
  final String grapeVariety;
  final int vintage;
  final double rating;
  final double priceLei;
  final String imageUrl;

  /// Описание на разных языках: {'ru': ..., 'ro': ..., 'en': ...}.
  final LocalizedText description;

  Wine({
    required this.id,
    required this.name,
    this.wineryId,
    required this.wineryName,
    required this.type,
    required this.grapeVariety,
    required this.vintage,
    required this.rating,
    required this.priceLei,
    required this.imageUrl,
    required this.description,
  });

  String descriptionFor(String languageCode) =>
      localizedFor(description, languageCode);

  // Фабричный конструктор для парсинга JSON из API (Supabase)
  factory Wine.fromJson(Map<String, dynamic> json) {
    final winery = json['winery'];

    return Wine(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      wineryId: json['winery_id']?.toString(),
      // При запросе с join винодельня приходит вложенным объектом
      wineryName: winery is Map
          ? winery['name'] ?? ''
          : json['winery_name'] ?? json['wineryName'] ?? '',
      type: json['type'] ?? '',
      grapeVariety: json['grape_variety'] ?? json['grapeVariety'] ?? '',
      vintage: json['vintage'] is int
          ? json['vintage']
          : int.tryParse(json['vintage']?.toString() ?? '0') ?? 0,
      rating: _toDouble(json['rating']),
      priceLei: _toDouble(json['avg_price_lei'] ?? json['priceLei']),
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? '',
      description: parseLocalizedText(json['description']),
    );
  }

  static double _toDouble(Object? value) => value is num
      ? value.toDouble()
      : double.tryParse(value?.toString() ?? '') ?? 0.0;

  // Метод для конвертации объекта обратно в JSON (если потребуется)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'winery_id': wineryId,
      'winery_name': wineryName,
      'type': type,
      'grape_variety': grapeVariety,
      'vintage': vintage,
      'rating': rating,
      'avg_price_lei': priceLei,
      'image_url': imageUrl,
      'description': description,
    };
  }
}
