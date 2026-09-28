import 'package:flutter_test/flutter_test.dart';
import 'package:wine_explorer/data/mock_data.dart';
import 'package:wine_explorer/data/wine_filter.dart';

void main() {
  List<String> names(WineFilter f) =>
      f.apply(mockWines).map((w) => w.name).toList();

  test('без фильтров — все вина, лучшие по рейтингу сверху', () {
    final result = names(const WineFilter());
    expect(result, hasLength(mockWines.length));
    expect(result.first, 'Viorica de Purcari'); // 4.9
  });

  test('поиск по названию, винодельне и сорту без учёта регистра', () {
    expect(names(const WineFilter(query: 'purcari')), ['Viorica de Purcari']);
    expect(names(const WineFilter(query: 'MERLOT')), ['Et Cetera Merlot']);
    expect(names(const WineFilter(query: 'vartely')), hasLength(2));
  });

  test('несколько типов объединяются через «или»', () {
    final result = const WineFilter(types: {'rose_dry', 'sparkling'})
        .apply(mockWines);
    expect(result.map((w) => w.type).toSet(), {'rose_dry', 'sparkling'});
    expect(result, hasLength(2));
  });

  test('фильтры складываются через «и»', () {
    const f = WineFilter(
      types: {'red_dry'},
      wineries: {'Château Vartely'},
      price: PriceRange(100, 200),
    );
    expect(names(f), ['Fetească Neagră Premium']);
    expect(f.activeCount, 3);
  });

  test('сортировка по цене', () {
    final asc = const WineFilter(sort: WineSort.priceAsc).apply(mockWines);
    expect(asc.first.priceLei, 130);
    expect(asc.last.priceLei, 320);
    final desc = const WineFilter(sort: WineSort.priceDesc).apply(mockWines);
    expect(desc.first.priceLei, 320);
  });

  test('сброс сохраняет поиск и сортировку', () {
    const f = WineFilter(query: 'x', types: {'red_dry'}, sort: WineSort.name);
    expect(f.cleared.types, isEmpty);
    expect(f.cleared.query, 'x');
    expect(f.cleared.sort, WineSort.name);
  });

  test('границы цены округляются до десятков', () {
    final b = priceBounds(mockWines);
    expect(b.min, 130);
    expect(b.max, 320);
  });
}
