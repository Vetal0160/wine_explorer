import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wine_explorer/core/age_gate_controller.dart';
import 'package:wine_explorer/core/favorites_controller.dart';
import 'package:wine_explorer/core/locale_controller.dart';
import 'package:wine_explorer/core/share.dart';
import 'package:wine_explorer/core/wine_notes_controller.dart';
import 'package:wine_explorer/data/catalog_store.dart';
import 'package:wine_explorer/l10n/app_localizations_ru.dart';
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
    await loadWineNotes();
    await confirmAge();
    await catalog.load();
  });

  test(
    'заметка сохраняется, кладёт вино в подвал и переживает перезапуск',
    () async {
      await saveWineNote(
        '2',
        WineNote(rating: 5, text: 'Отлично к рыбе', updatedAt: DateTime(2026)),
      );
      expect(isFavorite('2'), isTrue);

      wineNotes.value = {};
      await loadWineNotes();
      expect(wineNotes.value['2']?.rating, 5);
      expect(wineNotes.value['2']?.text, 'Отлично к рыбе');
    },
  );

  test('пустая заметка удаляет существующую', () async {
    await saveWineNote('2', WineNote(rating: 3, updatedAt: DateTime(2026)));
    await saveWineNote('2', WineNote(updatedAt: DateTime(2026)));
    expect(wineNotes.value.containsKey('2'), isFalse);
  });

  test('текст «Поделиться» содержит главное о вине', () {
    final l10n = AppLocalizationsRu();
    final wine = catalog.wineById('2')!;
    final text = wineShareText(l10n, wine, 'ru');
    expect(text, contains('Viorica de Purcari'));
    expect(text, contains('Château Purcari · 2023'));
    expect(text, contains('Белое сухое'));
    expect(text, contains('~145 MDL'));
    expect(text, contains('Свежий вкус'));
    expect(text, contains('Moldova Wine Explorer'));

    final winery = catalog.wineryFor(wine)!;
    final wineryText = wineryShareText(l10n, winery, 'ru');
    expect(wineryText, contains('Château Purcari'));
    expect(wineryText, contains('maps.google.com/?q=46.525,29.865'));
  });

  testWidgets('заметка из карточки вина видна в карточке и в подвале', (
    tester,
  ) async {
    await tester.pumpWidget(const WineExplorerApp());
    await settle(tester);

    await tester.tap(find.text('Viorica de Purcari'));
    await settle(tester);
    // Кнопка внизу списка; прокручиваем, пока она не окажется над нижней панелью
    await tester.dragUntilVisible(
      find.text('Добавить заметку'),
      find.byType(CustomScrollView),
      const Offset(0, -300),
    );
    await settle(tester);
    await tester.tap(find.text('Добавить заметку'));
    await settle(tester);
    expect(find.text('Моя оценка'), findsOneWidget);

    await tester.tap(find.byTooltip('4'));
    await tester.enterText(find.byType(TextField).first, 'Свежее, с мускатом');
    await tester.enterText(find.byType(TextField).last, 'Магазин у дома');
    await tester.tap(find.text('Сохранить'));
    await settle(tester);

    expect(find.text('Свежее, с мускатом'), findsOneWidget);
    expect(isFavorite('2'), isTrue);
    expect(wineNotes.value['2']?.rating, 4);

    // Назад в каталог и в подвал
    tester.state<NavigatorState>(find.byType(Navigator).first).pop();
    await settle(tester);
    await tester.tap(find.text('Подвал'));
    await settle(tester);
    expect(find.text('Свежее, с мускатом'), findsOneWidget);
    expect(find.text('Магазин у дома'), findsOneWidget);
  });
}
