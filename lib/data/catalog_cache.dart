import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/grape.dart';
import '../models/wine.dart';
import '../models/winery.dart';

/// Сохранённая копия каталога.
class CachedCatalog {
  final List<Wine> wines;
  final List<Winery> wineries;
  final List<Grape> grapes;
  final DateTime savedAt;

  const CachedCatalog({
    required this.wines,
    required this.wineries,
    this.grapes = const [],
    required this.savedAt,
  });
}

/// Последний загруженный каталог на телефоне — чтобы работать без интернета.
class CatalogCache {
  // При несовместимом изменении формата — поднять версию, старый кэш забудется
  static const _key = 'catalog_cache_v1';

  Future<CachedCatalog?> read() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null) return null;

      final json = jsonDecode(raw) as Map<String, dynamic>;
      return CachedCatalog(
        wines: (json['wines'] as List)
            .map((e) => Wine.fromJson(e as Map<String, dynamic>))
            .toList(),
        wineries: (json['wineries'] as List)
            .map((e) => Winery.fromJson(e as Map<String, dynamic>))
            .toList(),
        // В кэше старых версий сортов нет
        grapes: ((json['grapes'] as List?) ?? const [])
            .map((e) => Grape.fromJson(e as Map<String, dynamic>))
            .toList(),
        savedAt: DateTime.parse(json['savedAt'] as String),
      );
    } catch (_) {
      // Повреждённый или устаревший кэш — просто загрузим заново
      return null;
    }
  }

  Future<void> write(
    List<Wine> wines,
    List<Winery> wineries, [
    List<Grape> grapes = const [],
  ]) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode({
        'savedAt': DateTime.now().toIso8601String(),
        'wines': wines.map((w) => w.toJson()).toList(),
        'wineries': wineries.map((w) => w.toJson()).toList(),
        'grapes': grapes.map((g) => g.toJson()).toList(),
      }),
    );
  }
}
