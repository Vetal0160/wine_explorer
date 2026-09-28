import '../models/wine.dart';
import '../models/winery.dart';
import 'mock_data.dart';

/// Источник данных каталога. Экраны не знают, откуда приходят данные.
abstract class WineRepository {
  Future<List<Wine>> fetchWines();
  Future<List<Winery>> fetchWineries();
}

/// Тестовые данные — пока Supabase не настроен и в тестах.
class MockWineRepository implements WineRepository {
  @override
  Future<List<Wine>> fetchWines() async => mockWines;

  @override
  Future<List<Winery>> fetchWineries() async => mockWineries;
}
