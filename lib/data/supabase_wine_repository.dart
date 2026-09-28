import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/wine.dart';
import '../models/winery.dart';
import 'wine_repository.dart';

/// Каталог из Supabase (таблицы описаны в supabase/migrations).
class SupabaseWineRepository implements WineRepository {
  SupabaseClient get _db => Supabase.instance.client;

  @override
  Future<List<Wine>> fetchWines() async {
    // Название винодельни подтягиваем через связь winery_id → wineries
    final rows = await _db
        .from('wines')
        .select('*, winery:wineries(name)')
        .order('rating', ascending: false);
    return rows.map(Wine.fromJson).toList();
  }

  @override
  Future<List<Winery>> fetchWineries() async {
    final rows = await _db.from('wineries').select().order('name');
    return rows.map(Winery.fromJson).toList();
  }
}
