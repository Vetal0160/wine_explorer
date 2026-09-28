class Wine {
  final String id;
  final String name;
  final String wineryName;
  final String type;
  final String grapeVariety;
  final int vintage;
  final double rating;
  final double priceLei;
  final String imageUrl;
  final String description;

  Wine({
    required this.id,
    required this.name,
    required this.wineryName,
    required this.type,
    required this.grapeVariety,
    required this.vintage,
    required this.rating,
    required this.priceLei,
    required this.imageUrl,
    required this.description,
  });

  // Фабричный конструктор для парсинга JSON из API
  factory Wine.fromJson(Map<String, dynamic> json) {
    return Wine(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      wineryName: json['winery_name'] ?? json['wineryName'] ?? '',
      type: json['type'] ?? '',
      grapeVariety: json['grape_variety'] ?? json['grapeVariety'] ?? '',
      vintage: json['vintage'] is int ? json['vintage'] : int.tryParse(json['vintage']?.toString() ?? '0') ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      priceLei: (json['avg_price_lei'] ?? json['priceLei'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? '',
      description: json['description'] ?? '',
    );
  }

  // Метод для конвертации объекта обратно в JSON (если потребуется)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
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