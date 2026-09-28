import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _favoritesKey = 'favorite_wine_ids';

/// id вин, добавленных в «Мой подвал».
final ValueNotifier<Set<String>> favoriteWineIds = ValueNotifier<Set<String>>(
  {},
);

/// Загружает избранное (вызывается при старте приложения).
Future<void> loadFavorites() async {
  final prefs = await SharedPreferences.getInstance();
  favoriteWineIds.value = (prefs.getStringList(_favoritesKey) ?? []).toSet();
}

bool isFavorite(String wineId) => favoriteWineIds.value.contains(wineId);

/// Добавляет или убирает вино из избранного. Возвращает новое состояние.
Future<bool> toggleFavorite(String wineId) async {
  final ids = {...favoriteWineIds.value};
  final added = ids.add(wineId);
  if (!added) ids.remove(wineId);
  favoriteWineIds.value = ids;

  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(_favoritesKey, ids.toList());
  return added;
}
