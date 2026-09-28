import 'dart:async';

import 'package:flutter/foundation.dart';

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
      ]).timeout(timeout);
      wines = results[0] as List<Wine>;
      wineries = results[1] as List<Winery>;
      updatedAt = DateTime.now();
      _loaded = true;
      // Кэш — не критично: если не записался, просто не будет офлайн-копии
      unawaited(
        cache
            .write(wines, wineries)
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
