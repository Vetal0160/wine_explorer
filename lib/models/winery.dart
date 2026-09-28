import 'localized_text.dart';

class Winery {
  const Winery({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.region,
    this.description = const {},
    this.address,
    this.phone,
    this.website,
    this.hours = const {},
    this.hasTastings,
    this.tastingPriceLei,
    this.bookingRequired,
    this.foundedYear,
    this.imageUrl = '',
  });

  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String? region;

  /// Описание на разных языках.
  final LocalizedText description;
  final String? address;
  final String? phone;
  final String? website;

  /// Часы работы на разных языках: {'ru': 'Пн–Сб 10:00–18:00', ...}.
  final LocalizedText hours;

  /// null — неизвестно (не показываем), true/false — известно.
  final bool? hasTastings;
  final double? tastingPriceLei;
  final bool? bookingRequired;
  final int? foundedYear;
  final String imageUrl;

  String descriptionFor(String languageCode) =>
      localizedFor(description, languageCode);

  String hoursFor(String languageCode) => localizedFor(hours, languageCode);

  factory Winery.fromJson(Map<String, dynamic> json) => Winery(
    id: (json['id'] as num).toInt(),
    name: json['name'] as String,
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    region: json['region'] as String?,
    description: parseLocalizedText(json['description']),
    address: _nonEmpty(json['address']),
    phone: _nonEmpty(json['phone']),
    website: _nonEmpty(json['website']),
    hours: parseLocalizedText(json['hours']),
    hasTastings: json['has_tastings'] as bool?,
    tastingPriceLei: (json['tasting_price_lei'] as num?)?.toDouble(),
    bookingRequired: json['booking_required'] as bool?,
    foundedYear: (json['founded_year'] as num?)?.toInt(),
    imageUrl: json['image_url'] as String? ?? '',
  );

  static String? _nonEmpty(Object? value) {
    final s = value?.toString().trim();
    return s == null || s.isEmpty ? null : s;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'latitude': latitude,
    'longitude': longitude,
    'region': region,
    'description': description,
    'address': address,
    'phone': phone,
    'website': website,
    'hours': hours,
    'has_tastings': hasTastings,
    'tasting_price_lei': tastingPriceLei,
    'booking_required': bookingRequired,
    'founded_year': foundedYear,
    'image_url': imageUrl,
  };
}
