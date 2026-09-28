import 'package:flutter/foundation.dart';

import '../models/wine.dart';
import '../models/winery.dart';
import 'wine_repository.dart';

/// Загруженный каталог: вина и винодельни + состояние загрузки.
class CatalogStore extends ChangeNotifier {
  WineRepository repository = MockWineRepository();

  List<Wine> wines = const [];
  List<Winery> wineries = const [];
  bool isLoading = false;
  Object? error;
  bool _loaded = false;

  /// Данные хотя бы раз успешно загрузились.
  bool get hasData => _loaded;

  Future<void> load() async {
    if (isLoading) return;
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        repository.fetchWines(),
        repository.fetchWineries(),
      ]);
      wines = results[0] as List<Wine>;
      wineries = results[1] as List<Winery>;
      _loaded = true;
    } catch (e) {
      debugPrint('Не удалось загрузить каталог: $e');
      error = e;
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
