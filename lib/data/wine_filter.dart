import '../models/wine.dart';

enum WineSort { rating, priceAsc, priceDesc, vintage, name }

/// Диапазон цены в леях (включительно).
class PriceRange {
  final double min;
  final double max;

  const PriceRange(this.min, this.max);

  bool contains(double price) => price >= min && price <= max;

  @override
  bool operator ==(Object other) =>
      other is PriceRange && other.min == min && other.max == max;

  @override
  int get hashCode => Object.hash(min, max);
}

/// Поиск, фильтры и сортировка каталога. Неизменяемый — меняется через copyWith.
class WineFilter {
  final String query;
  final Set<String> types;
  final Set<String> wineries;

  /// null — любая цена.
  final PriceRange? price;
  final WineSort sort;

  const WineFilter({
    this.query = '',
    this.types = const {},
    this.wineries = const {},
    this.price,
    this.sort = WineSort.rating,
  });

  /// Сколько фильтров включено (поиск и сортировка не считаются).
  int get activeCount =>
      (types.isNotEmpty ? 1 : 0) +
      (wineries.isNotEmpty ? 1 : 0) +
      (price != null ? 1 : 0);

  /// Фильтры без поиска и сортировки.
  WineFilter get cleared => WineFilter(query: query, sort: sort);

  WineFilter copyWith({
    String? query,
    Set<String>? types,
    Set<String>? wineries,
    PriceRange? price,
    bool clearPrice = false,
    WineSort? sort,
  }) => WineFilter(
    query: query ?? this.query,
    types: types ?? this.types,
    wineries: wineries ?? this.wineries,
    price: clearPrice ? null : price ?? this.price,
    sort: sort ?? this.sort,
  );

  bool matches(Wine wine) {
    final q = query.trim().toLowerCase();
    if (q.isNotEmpty &&
        !wine.name.toLowerCase().contains(q) &&
        !wine.wineryName.toLowerCase().contains(q) &&
        !wine.grapeVariety.toLowerCase().contains(q)) {
      return false;
    }
    if (types.isNotEmpty && !types.contains(wine.type)) return false;
    if (wineries.isNotEmpty && !wineries.contains(wine.wineryName)) {
      return false;
    }
    if (price != null && !price!.contains(wine.priceLei)) return false;
    return true;
  }

  List<Wine> apply(List<Wine> wines) {
    final result = wines.where(matches).toList();
    int byName(Wine a, Wine b) =>
        a.name.toLowerCase().compareTo(b.name.toLowerCase());

    result.sort((a, b) {
      final c = switch (sort) {
        WineSort.rating => b.rating.compareTo(a.rating),
        WineSort.priceAsc => a.priceLei.compareTo(b.priceLei),
        WineSort.priceDesc => b.priceLei.compareTo(a.priceLei),
        WineSort.vintage => b.vintage.compareTo(a.vintage),
        WineSort.name => 0,
      };
      // При равенстве — по названию, чтобы порядок был стабильным
      return c != 0 ? c : byName(a, b);
    });
    return result;
  }
}

/// Границы ползунка цены: округляем до десятков, чтобы шаги были круглыми.
PriceRange priceBounds(List<Wine> wines) {
  if (wines.isEmpty) return const PriceRange(0, 0);
  var min = wines.first.priceLei;
  var max = wines.first.priceLei;
  for (final w in wines) {
    if (w.priceLei < min) min = w.priceLei;
    if (w.priceLei > max) max = w.priceLei;
  }
  return PriceRange(
    (min / 10).floorToDouble() * 10,
    (max / 10).ceilToDouble() * 10,
  );
}
