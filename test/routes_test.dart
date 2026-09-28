import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wine_explorer/core/age_gate_controller.dart';
import 'package:wine_explorer/core/external_links.dart';
import 'package:wine_explorer/core/favorites_controller.dart';
import 'package:wine_explorer/core/locale_controller.dart';
import 'package:wine_explorer/data/catalog_store.dart';
import 'package:wine_explorer/main.dart';
import 'package:wine_explorer/models/wine_route.dart';
import 'package:wine_explorer/screens/route_detail_screen.dart';
import 'package:wine_explorer/screens/routes_screen.dart';

Future<void> settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 600));
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await setAppLocale('ru');
    await loadFavorites();
    await confirmAge();
    await catalog.load();
  });

  test('удалённая винодельня (null в winery_ids) пропускается', () {
    final r = WineRoute.fromJson({
      'id': 'x',
      'title': {'ru': 'Тест'},
      'winery_ids': [3, null, 4],
    });
    expect(r.wineryIds, [3, 4]);
    expect(WineRoute.fromJson(r.toJson()).wineryIds, [3, 4]);
  });

  test('остановки по порядку, маршруты винодельни, расстояние', () {
    final codru = catalog.routes.firstWhere((r) => r.id == 'codru-cellars');
    final stops = catalog.stopsOf(codru);
    expect(stops.map((w) => w.name), ['Cricova', 'Mileștii Mici']);
    expect(
      catalog.routesWith(stops.first).map((r) => r.id),
      contains('codru-cellars'),
    );
    // Крикова → Милештий Мичь ≈ 27 км по прямой
    expect(routeDistanceKm(stops), inInclusiveRange(20, 35));
  });

  test('ссылка Google Карт: последняя точка — цель, остальные — waypoints', () {
    final uri = routeWithStopsUri([
      (lat: 47.1, lng: 28.8),
      (lat: 47.0, lng: 28.7),
      (lat: 46.9, lng: 28.8),
    ]);
    expect(uri.host, 'www.google.com');
    expect(uri.queryParameters['destination'], '46.9,28.8');
    expect(uri.queryParameters['waypoints'], '47.1,28.8|47.0,28.7');
    expect(uri.queryParameters['travelmode'], 'driving');
  });

  testWidgets('Карта → «Маршруты» → страница маршрута', (tester) async {
    await tester.pumpWidget(const WineExplorerApp());
    await settle(tester);
    await tester.tap(find.text('Карта'));
    await settle(tester);

    await tester.tap(find.widgetWithText(FilledButton, 'Маршруты'));
    await settle(tester);
    expect(find.byType(RoutesScreen), findsOneWidget);
    expect(find.text('Подземные галереи Кодр'), findsOneWidget);

    await tester.tap(find.text('Подземные галереи Кодр'));
    await settle(tester);
    expect(find.byType(RouteDetailScreen), findsOneWidget);
    expect(find.text('Открыть маршрут в Google Картах'), findsOneWidget);
    expect(find.textContaining('трезвом водителе'), findsOneWidget);
  });
}
