import '../models/grape.dart';
import '../models/wine.dart';
import '../models/wine_route.dart';
import '../models/winery.dart';
import 'mock_data.dart';

/// Источник данных каталога. Экраны не знают, откуда приходят данные.
abstract class WineRepository {
  Future<List<Wine>> fetchWines();
  Future<List<Winery>> fetchWineries();
  Future<List<Grape>> fetchGrapes();
  Future<List<WineRoute>> fetchRoutes();
}

/// Тестовые данные — пока Supabase не настроен и в тестах.
class MockWineRepository implements WineRepository {
  @override
  Future<List<Wine>> fetchWines() async => mockWines;

  @override
  Future<List<Winery>> fetchWineries() async => mockWineries;

  @override
  Future<List<Grape>> fetchGrapes() async => mockGrapes;

  @override
  Future<List<WineRoute>> fetchRoutes() async => mockRoutes;
}
