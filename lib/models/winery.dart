class Winery {
  const Winery({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.region,
  });

  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String? region;

  factory Winery.fromJson(Map<String, dynamic> json) => Winery(
        id: json['id'] as int,
        name: json['name'] as String,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        region: json['region'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'region': region,
      };
}
