import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wine_explorer/core/age_gate_controller.dart';
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
    await loadAgeConfirmed();
    await catalog.load();
  });

  testWidgets('первый запуск: «Да» открывает каталог и запоминается', (
    tester,
  ) async {
    await tester.pumpWidget(const WineExplorerApp());
    await settle(tester);

    expect(find.text('Вам есть 18 лет?'), findsOneWidget);
    expect(find.text('Вина'), findsNothing);

    await tester.tap(find.text('Да, мне есть 18'));
    await settle(tester);
    expect(find.text('Вина'), findsOneWidget);

    // После перезапуска не спрашиваем снова
    ageConfirmed.value = false;
    await loadAgeConfirmed();
    expect(ageConfirmed.value, isTrue);
  });

  testWidgets('«Нет» не пускает в приложение, «Назад» возвращает вопрос', (
    tester,
  ) async {
    await tester.pumpWidget(const WineExplorerApp());
    await settle(tester);

    await tester.tap(find.text('Нет'));
    await settle(tester);
    expect(find.text('Приложение доступно с 18 лет'), findsOneWidget);
    expect(find.text('Да, мне есть 18'), findsNothing);
    expect(ageConfirmed.value, isFalse);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Назад'));
    await settle(tester);
    expect(find.text('Вам есть 18 лет?'), findsOneWidget);
  });
}
