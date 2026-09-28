import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:wine_explorer/core/map_clusters.dart';

void main() {
  // Кишинёв, Крикова (~15 км) и Пуркарь (~100 км)
  const points = {
    'chisinau': LatLng(47.0105, 28.8638),
    'cricova': LatLng(47.1386, 28.8620),
    'purcari': LatLng(46.5348, 29.8661),
  };
  List<List<String>> groups(double zoom) => clusterMarkers(
    points.keys,
    (k) => points[k]!,
    zoom,
  ).map((c) => c.items..sort()).toList();

  test('на масштабе всей страны близкие точки объединяются', () {
    final g = groups(7);
    expect(g, contains(equals(['chisinau', 'cricova'])));
    expect(g, contains(equals(['purcari'])));
  });

  test('при приближении группы распадаются', () {
    expect(groups(12), hasLength(3));
  });

  test('центр группы — среднее координат', () {
    final c = clusterMarkers(
      ['a', 'b'],
      (k) => k == 'a' ? const LatLng(46, 28) : const LatLng(46.001, 28.001),
      7,
    ).single;
    expect(c.center.latitude, closeTo(46.0005, 1e-9));
    expect(c.isSingle, isFalse);
  });
}
