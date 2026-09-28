import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:wine_explorer/core/location_controller.dart';
import 'package:wine_explorer/core/map_style.dart';

void main() {
  test('расстояние Кишинёв → Крикова около 15 км', () {
    const chisinau = LatLng(47.0105, 28.8638);
    final km = distanceKm(chisinau, 47.1386, 28.8620);
    expect(km, inInclusiveRange(13, 16));
  });

  test('формат расстояния: до 10 км с десятыми, дальше целыми', () {
    expect(formatKm(4.24), '4.2');
    expect(formatKm(37.6), '38');
  });

  test(
    'стиль по умолчанию — приглушённая OSM; MapTiler без ключа не показываем',
    () {
      expect(defaultMapStyle, MapStyle.muted);
      expect(MapStyle.muted.colorMatrix, hasLength(20));
      expect(MapStyle.osm.colorMatrix, isNull);
      expect(MapStyle.maptiler.effective, MapStyle.muted);
      expect(MapStyle.maptiler.url, isNot(contains('maptiler')));
    },
  );
}
