import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wine_explorer/core/age_gate_controller.dart';
import 'package:wine_explorer/core/favorites_controller.dart';
import 'package:wine_explorer/core/locale_controller.dart';
import 'package:wine_explorer/data/catalog_store.dart';
import 'package:wine_explorer/data/mock_data.dart';
import 'package:wine_explorer/data/wine_repository.dart';
import 'package:wine_explorer/main.dart';
import 'package:wine_explorer/models/grape.dart';
import 'package:wine_explorer/models/wine.dart';
import 'package:wine_explorer/models/wine_route.dart';
import 'package:wine_explorer/models/winery.dart';

/// Имитирует отсутствие интернета.
class _OfflineRepository implements WineRepository {
  @override
  Future<List<Wine>> fetchWines() async => throw Exception('нет сети');

  @override
  Future<List<Winery>> fetchWineries() async => throw Exception('нет сети');

  @override
  Future<List<Grape>> fetchGrapes() async => throw Exception('нет сети');

  @override
  Future<List<WineRoute>> fetchRoutes() async => throw Exception('нет сети');
}

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
  });

  test(
    'удачная загрузка сохраняется, без сети каталог берётся из кэша',
    () async {
      final online = CatalogStore();
      await online.load();
      // Запись в кэш идёт в фоне
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final offline = CatalogStore()..repository = _OfflineRepository();
      await offline.load();

      expect(offline.hasData, isTrue);
      expect(offline.isOffline, isTrue);
      expect(offline.wines, hasLength(mockWines.length));
      expect(offline.wineries, hasLength(mockWineries.length));
      expect(offline.updatedAt, isNotNull);
      // Описания на всех языках пережили сохранение
      expect(
        offline.wineById('2')!.descriptionFor('en'),
        startsWith('Fresh taste'),
      );
    },
  );

  test('без сети и без кэша — ошибка, данных нет', () async {
    final store = CatalogStore()..repository = _OfflineRepository();
    await store.load();
    expect(store.hasData, isFalse);
    expect(store.error, isNotNull);
  });

  test('зависший запрос обрывается по таймауту', () async {
    final store = CatalogStore()
      ..repository = _HangingRepository()
      ..timeout = const Duration(milliseconds: 100);
    await store.load();
    expect(store.error, isNotNull);
    expect(store.isLoading, isFalse);
  });

  testWidgets('без сети показывается плашка и сохранённые вина', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await CatalogStore().load();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      catalog.repository = _OfflineRepository();
      await catalog.load();
    });
    addTearDown(() => catalog.repository = MockWineRepository());

    await tester.pumpWidget(const WineExplorerApp());
    await settle(tester);

    expect(find.textContaining('Нет подключения'), findsOneWidget);
    expect(find.text('Viorica de Purcari'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Повторить'), findsOneWidget);
  });
}

class _HangingRepository implements WineRepository {
  @override
  Future<List<Wine>> fetchWines() => Future.delayed(const Duration(hours: 1));

  @override
  Future<List<Winery>> fetchWineries() =>
      Future.delayed(const Duration(hours: 1));

  @override
  Future<List<Grape>> fetchGrapes() => Future.delayed(const Duration(hours: 1));

  @override
  Future<List<WineRoute>> fetchRoutes() =>
      Future.delayed(const Duration(hours: 1));
}
