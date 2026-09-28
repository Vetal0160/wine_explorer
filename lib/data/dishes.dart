/// Блюда молдавской кухни для подбора вина.
enum Dish {
  placinte('🥧', ['red_dry', 'rose_dry']),
  tochitura('🍲', ['red_dry']),
  zeama('🍜', ['white_dry']),
  mamaliga('🌽', ['white_dry', 'rose_dry']),
  grill('🍖', ['red_dry']),
  fish('🐟', ['white_dry', 'sparkling']),
  cheese('🧀', ['red_dry', 'white_dry']),
  dessert('🍰', ['sparkling']);

  const Dish(this.emoji, this.wineTypes);

  final String emoji;

  /// Коды типов вин, которые подходят к блюду (в порядке предпочтения).
  final List<String> wineTypes;
}
