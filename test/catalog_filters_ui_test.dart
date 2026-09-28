import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wine_explorer/core/favorites_controller.dart';
import 'package:wine_explorer/core/locale_controller.dart';
import 'package:wine_explorer/data/catalog_store.dart';
import 'package:wine_explorer/main.dart';

Future<void> settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await setAppLocale('ru');
    await loadFavorites();
    await catalog.load();
  });

  testWidgets('чип типа фильтрует список', (tester) async {
    await tester.pumpWidget(const WineExplorerApp());
    await settle(tester);
    expect(find.text('Найдено 8 вин'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilterChip, 'Белое сухое'));
    await settle(tester);
    expect(find.text('Найдено 2 вина'), findsOneWidget);
    expect(find.text('Viorica de Purcari'), findsOneWidget);
    expect(find.text('Fetească Neagră Premium'), findsNothing);
  });

  testWidgets('панель фильтров: винодельня и «Показать»', (tester) async {
    await tester.pumpWidget(const WineExplorerApp());
    await settle(tester);

    await tester.tap(find.widgetWithText(ActionChip, 'Фильтры'));
    await settle(tester);
    expect(find.text('Показать (8)'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilterChip, 'Château Vartely'));
    await settle(tester);
    expect(find.text('Показать (2)'), findsOneWidget);

    await tester.tap(find.text('Показать (2)'));
    await settle(tester);
    expect(find.text('Найдено 2 вина'), findsOneWidget);
    // Бейдж с числом активных фильтров панели
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('сортировка по цене', (tester) async {
    await tester.pumpWidget(const WineExplorerApp());
    await settle(tester);

    await tester.tap(find.text('По рейтингу'));
    await settle(tester);
    await tester.tap(find.text('Сначала дешёвые').last);
    await settle(tester);
    expect(find.text('Сначала дешёвые'), findsOneWidget);
    // Самое дешёвое — Asconi за 130
    expect(find.text('Asconi Sauvignon Blanc'), findsOneWidget);
  });
}
