import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wine_explorer/core/age_gate_controller.dart';
import 'package:wine_explorer/core/favorites_controller.dart';
import 'package:wine_explorer/core/locale_controller.dart';
import 'package:wine_explorer/data/catalog_store.dart';
import 'package:wine_explorer/l10n/app_localizations.dart';
import 'package:wine_explorer/models/winery.dart';
import 'package:wine_explorer/main.dart';
import 'package:wine_explorer/screens/winery_detail_screen.dart';

Future<void> settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

Widget _app(Widget home) => MaterialApp(
  locale: const Locale('ru'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: home,
);

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await setAppLocale('ru');
    await loadFavorites();
    await confirmAge();
    await catalog.load();
  });

  test('новые поля винодельни переживают JSON (кэш, Supabase)', () {
    const winery = Winery(
      id: 9,
      name: 'Test',
      latitude: 47,
      longitude: 28,
      description: {'ru': 'Описание', 'en': 'About'},
      phone: '+373 22 000 000',
      hours: {'ru': 'Пн–Пт 9–18'},
      hasTastings: true,
      tastingPriceLei: 250,
      foundedYear: 1990,
    );
    final copy = Winery.fromJson(winery.toJson());
    expect(copy.descriptionFor('en'), 'About');
    expect(copy.descriptionFor('ro'), 'Описание'); // нет перевода — русский
    expect(copy.phone, '+373 22 000 000');
    expect(copy.hoursFor('ru'), 'Пн–Пт 9–18');
    expect(copy.hasTastings, isTrue);
    expect(copy.tastingPriceLei, 250);
    expect(copy.foundedYear, 1990);
    expect(copy.website, isNull);
  });

  testWidgets('из карточки вина открывается страница винодельни', (
    tester,
  ) async {
    await tester.pumpWidget(const WineExplorerApp());
    await settle(tester);

    await tester.tap(find.text('Viorica de Purcari'));
    await settle(tester);
    await tester.tap(find.text('Château Purcari'));
    await settle(tester);

    expect(find.byType(WineryDetailScreen), findsOneWidget);
    expect(find.textContaining('Основана в 1827 году'), findsOneWidget);
    expect(find.textContaining('старейших виноделен'), findsOneWidget);
  });

  testWidgets('пустые поля не показываются, заполненные — показываются', (
    tester,
  ) async {
    const bare = Winery(id: 99, name: 'Bare', latitude: 47, longitude: 28);
    await tester.pumpWidget(_app(const WineryDetailScreen(winery: bare)));
    await settle(tester);
    expect(
      find.text('Подробная информация пока не добавлена.'),
      findsOneWidget,
    );
    expect(find.text('Телефон'), findsNothing);
    expect(find.text('Дегустации'), findsNothing);
    expect(find.text('Адрес'), findsOneWidget); // маршрут есть всегда

    const full = Winery(
      id: 98,
      name: 'Full',
      latitude: 47,
      longitude: 28,
      phone: '+373 22 000 000',
      website: 'https://www.example.md/',
      hasTastings: true,
      tastingPriceLei: 300,
      bookingRequired: true,
    );
    await tester.pumpWidget(_app(const WineryDetailScreen(winery: full)));
    await settle(tester);
    expect(find.text('+373 22 000 000'), findsOneWidget);
    expect(find.text('example.md'), findsOneWidget);
    expect(
      find.text('Проводятся · от 300 MDL · Нужна предварительная запись'),
      findsOneWidget,
    );
  });
}
