import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wine_explorer/data/wine_filter.dart';
import 'package:wine_explorer/l10n/app_localizations.dart';
import 'package:wine_explorer/models/wine.dart';
import 'package:wine_explorer/widgets/wine_card.dart';

Wine _wine(
  String name, {
  double rating = 0,
  double price = 0,
  int vintage = 0,
}) => Wine(
  id: name,
  name: name,
  wineryName: 'Test Winery',
  type: 'sparkling',
  grapeVariety: '',
  vintage: vintage,
  rating: rating,
  priceLei: price,
  imageUrl: '',
  description: const {},
);

void main() {
  testWidgets('без рейтинга, цены и года — не показываем «0»', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: WineCard(wine: _wine('Brut NV'))),
      ),
    );
    await tester.pump();

    expect(find.text('Test Winery'), findsOneWidget); // без «• 0»
    expect(find.text('0.0'), findsNothing);
    expect(find.textContaining('MDL'), findsNothing);
  });

  test('сортировка по цене: вина без цены в конце в обе стороны', () {
    final wines = [
      _wine('A', price: 200),
      _wine('Без цены'),
      _wine('B', price: 100),
    ];
    List<String> sorted(WineSort s) =>
        WineFilter(sort: s).apply(wines).map((w) => w.name).toList();

    expect(sorted(WineSort.priceAsc), ['B', 'A', 'Без цены']);
    expect(sorted(WineSort.priceDesc), ['A', 'B', 'Без цены']);
  });

  test('границы цены не учитывают вина без цены', () {
    final b = priceBounds([_wine('x', price: 145), _wine('y')]);
    expect(b.min, 140);
    expect(b.max, 150);
  });
}
