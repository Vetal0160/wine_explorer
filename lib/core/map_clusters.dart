import 'dart:math' as math;
import 'dart:ui' show Offset;

import 'package:latlong2/latlong.dart';

/// Группа маркеров, близких на экране при текущем масштабе.
class MarkerCluster<T> {
  final List<T> items;
  final LatLng center;

  const MarkerCluster(this.items, this.center);

  bool get isSingle => items.length == 1;
}

/// Точка в пикселях «мировой» карты Web Mercator на масштабе [zoom].
Offset projectToPixels(LatLng p, double zoom) {
  final scale = 256 * math.pow(2, zoom);
  final lat = p.latitude.clamp(-85.05112878, 85.05112878) * math.pi / 180;
  final x = (p.longitude + 180) / 360 * scale;
  final y =
      (1 - math.log(math.tan(lat) + 1 / math.cos(lat)) / math.pi) / 2 * scale;
  return Offset(x, y);
}

/// Жадная кластеризация: маркер попадает в первую группу, чей «якорь»
/// ближе [radiusPx] пикселей, иначе начинает новую. Для десятков точек
/// этого достаточно; порядок входа не влияет на результат (сортируем).
List<MarkerCluster<T>> clusterMarkers<T>(
  Iterable<T> items,
  LatLng Function(T) position,
  double zoom, {
  double radiusPx = 44,
}) {
  final sorted = items.toList()
    ..sort((a, b) {
      final pa = position(a), pb = position(b);
      final c = pa.latitude.compareTo(pb.latitude);
      return c != 0 ? c : pa.longitude.compareTo(pb.longitude);
    });

  final anchors = <Offset>[];
  final groups = <List<T>>[];
  for (final item in sorted) {
    final px = projectToPixels(position(item), zoom);
    var placed = false;
    for (var i = 0; i < anchors.length; i++) {
      if ((anchors[i] - px).distance <= radiusPx) {
        groups[i].add(item);
        placed = true;
        break;
      }
    }
    if (!placed) {
      anchors.add(px);
      groups.add([item]);
    }
  }

  return [
    for (final g in groups)
      MarkerCluster(
        g,
        LatLng(
          g.map((e) => position(e).latitude).reduce((a, b) => a + b) / g.length,
          g.map((e) => position(e).longitude).reduce((a, b) => a + b) /
              g.length,
        ),
      ),
  ];
}
