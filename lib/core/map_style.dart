import 'package:flutter/widgets.dart';

/// Стиль карты. Выбирается при сборке:
///   flutter run --dart-define=MAP_STYLE=warm
/// MapTiler нужен ключ: --dart-define=MAPTILER_KEY=... (бесплатный аккаунт на maptiler.com);
/// без ключа вместо него — [MapStyle.muted].
enum MapStyle {
  /// Стандартная OpenStreetMap.
  osm,

  /// OpenStreetMap, приглушённая в приложении: светлая, почти без цвета —
  /// бордовые маркеры на ней ярче всего. Бесплатно, без ключей.
  muted,

  /// OpenStreetMap в тёплом «винтажном» тоне. Бесплатно, без ключей.
  warm,

  /// MapTiler «Dataviz» — дизайнерская светлая карта (нужен ключ).
  maptiler;

  static const _mapTilerKey = String.fromEnvironment('MAPTILER_KEY');

  /// Стиль, который реально можно показать (MapTiler без ключа — нельзя).
  MapStyle get effective =>
      this == maptiler && _mapTilerKey.isEmpty ? muted : this;

  String get url => switch (effective) {
    maptiler =>
      'https://api.maptiler.com/maps/dataviz/256/{z}/{x}/{y}{r}.png?key=$_mapTilerKey',
    _ => 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  };

  List<String> get subdomains => const [];

  /// Тайлы @2x для экранов высокой плотности есть только у MapTiler.
  bool get retina => effective == maptiler;

  String get attribution => effective == maptiler
      ? 'MapTiler · OpenStreetMap contributors'
      : 'OpenStreetMap contributors';

  /// Перекраска тайлов в приложении; null — как есть.
  List<double>? get colorMatrix => switch (effective) {
    muted => _lighten(_saturation(0.28), 0.88, 28),
    warm => _warmTint(_lighten(_sepia(0.3), 0.86, 30)),
    _ => null,
  };

  /// Оборачивает тайл в цветовой фильтр — для TileLayer.tileBuilder.
  Widget Function(BuildContext, Widget, Object)? get tileBuilder {
    final matrix = colorMatrix;
    if (matrix == null) return null;
    final filter = ColorFilter.matrix(matrix);
    return (context, tile, _) =>
        ColorFiltered(colorFilter: filter, child: tile);
  }
}

const _styleName = String.fromEnvironment('MAP_STYLE', defaultValue: 'muted');

final MapStyle defaultMapStyle = MapStyle.values.firstWhere(
  (s) => s.name.toLowerCase() == _styleName.toLowerCase(),
  orElse: () => MapStyle.muted,
);

// ---- Цветовые матрицы 4×5 (RGBA + сдвиг) ----

const _lr = 0.2126, _lg = 0.7152, _lb = 0.0722;

/// Насыщенность: 0 — серый, 1 — как есть.
List<double> _saturation(double s) => [
  _lr * (1 - s) + s, _lg * (1 - s), _lb * (1 - s), 0, 0, //
  _lr * (1 - s), _lg * (1 - s) + s, _lb * (1 - s), 0, 0, //
  _lr * (1 - s), _lg * (1 - s), _lb * (1 - s) + s, 0, 0, //
  0, 0, 0, 1, 0,
];

/// Сепия, смешанная с оригиналом: 0 — как есть, 1 — полная сепия.
List<double> _sepia(double t) {
  const sepia = [
    [0.393, 0.769, 0.189],
    [0.349, 0.686, 0.168],
    [0.272, 0.534, 0.131],
  ];
  final m = <double>[];
  for (var row = 0; row < 3; row++) {
    for (var col = 0; col < 3; col++) {
      final identity = row == col ? 1.0 : 0.0;
      m.add(identity * (1 - t) + sepia[row][col] * t);
    }
    m.addAll([0, 0]);
  }
  return m..addAll([0, 0, 0, 1, 0]);
}

/// Лёгкий бежевый оттенок: чуть больше красного, чуть меньше синего.
List<double> _warmTint(List<double> m) => [
  for (var i = 0; i < 20; i++) i == 4 ? m[i] + 6 : (i == 14 ? m[i] - 10 : m[i]),
];

/// Сжимает контраст ([scale] < 1) и осветляет ([offset] 0–255).
List<double> _lighten(List<double> m, double scale, double offset) => [
  for (var i = 0; i < 20; i++)
    if (i >= 15)
      m[i] // альфа-канал не трогаем
    else if (i % 5 == 4)
      m[i] + offset
    else
      m[i] * scale,
];
