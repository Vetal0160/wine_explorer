import 'localized_text.dart';

/// Винный маршрут: несколько виноделен по порядку.
class WineRoute {
  const WineRoute({
    required this.id,
    this.title = const {},
    this.description = const {},
    this.duration = const {},
    this.wineryIds = const [],
    this.imageUrl = '',
  });

  final String id;
  final LocalizedText title;
  final LocalizedText description;

  /// «1 день», «1–2 дня».
  final LocalizedText duration;

  /// Остановки по порядку.
  final List<int> wineryIds;
  final String imageUrl;

  String titleFor(String lang) => localizedFor(title, lang);
  String descriptionFor(String lang) => localizedFor(description, lang);
  String durationFor(String lang) => localizedFor(duration, lang);

  factory WineRoute.fromJson(Map<String, dynamic> json) => WineRoute(
    id: json['id'] as String,
    title: parseLocalizedText(json['title']),
    description: parseLocalizedText(json['description']),
    duration: parseLocalizedText(json['duration']),
    // Если винодельню удалили, в массиве может оказаться null — пропускаем
    wineryIds: ((json['winery_ids'] as List?) ?? const [])
        .whereType<num>()
        .map((e) => e.toInt())
        .toList(),
    imageUrl: json['image_url'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'duration': duration,
    'winery_ids': wineryIds,
    'image_url': imageUrl,
  };
}
