import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wine_explorer/core/age_gate_controller.dart';
import 'package:wine_explorer/core/favorites_controller.dart';
import 'package:wine_explorer/core/locale_controller.dart';
import 'package:wine_explorer/data/catalog_store.dart';
import 'package:wine_explorer/data/mock_data.dart';
import 'package:wine_explorer/main.dart';
import 'package:wine_explorer/models/grape.dart';
import 'package:wine_explorer/screens/grape_detail_screen.dart';

Future<void> settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await setAppLocale('ru');
    await loadFavorites();
    await confirmAge();
    await catalog.load();
  });

  test('название с этикетки находит сорт: регистр, диакритики, синонимы', () {
    expect(catalog.grapeByName('Fetească Neagră')?.id, 'feteasca-neagra');
    expect(catalog.grapeByName('feteasca neagra')?.id, 'feteasca-neagra');
    expect(catalog.grapeByName('Băbească Neagră')?.id, 'rara-neagra');
    // Похожие, но разные сорта не путаются
    expect(catalog.grapeByName('Fetească Albă')?.id, 'feteasca-alba');
    expect(catalog.grapeByName('Syrah'), isNull);
  });

  test('состав «Chardonnay, Pinot Noir» относится к обоим сортам', () {
    expect(splitGrapeVarieties('Chardonnay, Pinot Noir'), [
      'Chardonnay',
      'Pinot Noir',
    ]);
    final chardonnay = catalog.grapeByName('Chardonnay')!;
    final pinot = catalog.grapeByName('Pinot Noir')!;
    expect(catalog.winesOfGrape(chardonnay).map((w) => w.name), [
      'Cricova Brut',
    ]);
    expect(
      catalog.winesOfGrape(pinot).map((w) => w.name),
      containsAll(['Cricova Brut', 'Rosé de Mimi']),
    );
  });

  test('у каждого вина из тестовых данных все сорта есть в справочнике', () {
    for (final wine in mockWines) {
      for (final v in splitGrapeVarieties(wine.grapeVariety)) {
        expect(catalog.grapeByName(v), isNotNull, reason: '${wine.name}: $v');
      }
    }
  });

  testWidgets('вкладка «Сорта» → страница сорта с винами', (tester) async {
    await tester.pumpWidget(const WineExplorerApp());
    await settle(tester);

    await tester.tap(find.text('Сорта'));
    await settle(tester);
    expect(find.text('Местные сорта'), findsOneWidget);

    await tester.tap(find.text('Rară Neagră'));
    await settle(tester);
    expect(find.byType(GrapeDetailScreen), findsOneWidget);
    expect(find.text('Другие названия: Băbească Neagră'), findsOneWidget);
    expect(find.text('Rară Neagră Taraboste'), findsOneWidget);
  });

  testWidgets('из карточки вина нажатие на сорт открывает его страницу', (
    tester,
  ) async {
    await tester.pumpWidget(const WineExplorerApp());
    await settle(tester);

    await tester.tap(find.text('Viorica de Purcari'));
    await settle(tester);
    await tester.tap(find.widgetWithText(ActionChip, 'Viorica'));
    await settle(tester);

    expect(find.byType(GrapeDetailScreen), findsOneWidget);
    expect(find.text('Местный сорт'), findsOneWidget);
  });
}
