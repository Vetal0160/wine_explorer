import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/grape.dart';
import '../models/wine.dart';
import '../models/winery.dart';
import 'catalog_cache.dart';
import 'wine_repository.dart';

/// Загруженный каталог: вина и винодельни + состояние загрузки.
/// Последний удачный ответ сохраняется на телефоне — без интернета
/// показываем его.
class CatalogStore extends ChangeNotifier {
  WineRepository repository = MockWineRepository();
  CatalogCache cache = CatalogCache();

  /// Дольше не ждём: при плохой связи лучше показать сохранённые данные.
  Duration timeout = const Duration(seconds: 15);

  List<Wine> wines = const [];
  List<Winery> wineries = const [];
  List<Grape> grapes = const [];
  bool isLoading = false;
  Object? error;
  bool _loaded = false;

  /// Когда данные были получены с сервера (для кэша — время сохранения).
  DateTime? updatedAt;

  /// Данные есть — с сервера или из кэша.
  bool get hasData => _loaded;

  /// Сервер недоступен, показываем сохранённую копию.
  bool get isOffline => _loaded && error != null;

  /// Мгновенно показывает сохранённый каталог, пока идёт загрузка с сервера.
  Future<void> restoreFromCache() async {
    if (_loaded) return;
    final cached = await cache.read();
    if (cached == null || _loaded) return;
    wines = cached.wines;
    wineries = cached.wineries;
    grapes = cached.grapes;
    updatedAt = cached.savedAt;
    _loaded = true;
    notifyListeners();
  }

  Future<void> load() async {
    if (isLoading) return;
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        repository.fetchWines(),
        repository.fetchWineries(),
        // Справочник не критичен: не загрузился — каталог всё равно работает
        repository.fetchGrapes().catchError((Object e) {
          debugPrint('Сорта не загрузились: $e');
          return grapes;
        }),
      ]).timeout(timeout);
      wines = results[0] as List<Wine>;
      wineries = results[1] as List<Winery>;
      grapes = results[2] as List<Grape>;
      updatedAt = DateTime.now();
      _loaded = true;
      // Кэш — не критично: если не записался, просто не будет офлайн-копии
      unawaited(
        cache
            .write(wines, wineries, grapes)
            .catchError((Object e) => debugPrint('Кэш не сохранён: $e')),
      );
    } catch (e) {
      debugPrint('Не удалось загрузить каталог: $e');
      error = e;
      // Сервер недоступен — попробуем хотя бы сохранённую копию
      if (!_loaded) await restoreFromCache();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Wine? wineById(String id) {
    for (final wine in wines) {
      if (wine.id == id) return wine;
    }
    return null;
  }

  Winery? wineryById(int id) {
    for (final winery in wineries) {
      if (winery.id == id) return winery;
    }
    return null;
  }

  /// Винодельня вина: по id, а если его нет — по названию.
  Winery? wineryFor(Wine wine) {
    final id = int.tryParse(wine.wineryId ?? '');
    if (id != null) return wineryById(id);
    for (final winery in wineries) {
      if (winery.name == wine.wineryName) return winery;
    }
    return null;
  }

  /// Сорт по названию с этикетки (учитывает другие названия и диакритики).
  Grape? grapeByName(String name) {
    for (final grape in grapes) {
      if (grape.matchesName(name)) return grape;
    }
    return null;
  }

  /// Вина, в составе которых есть этот сорт.
  List<Wine> winesOfGrape(Grape grape) => wines
      .where((w) => splitGrapeVarieties(w.grapeVariety).any(grape.matchesName))
      .toList();

  /// Вина конкретной винодельни.
  List<Wine> winesOf(Winery winery) => wines
      .where(
        (w) => w.wineryId != null
            ? w.wineryId == winery.id.toString()
            : w.wineryName == winery.name,
      )
      .toList();
}

/// Общий каталог приложения.
final CatalogStore catalog = CatalogStore();
