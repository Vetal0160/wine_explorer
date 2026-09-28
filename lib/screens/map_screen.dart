import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/external_links.dart';
import '../core/location_controller.dart';
import '../core/map_style.dart';
import '../core/theme.dart';
import '../data/catalog_store.dart';
import '../l10n/app_localizations.dart';
import '../l10n/wine_type_labels.dart';
import '../models/winery.dart';
import '../widgets/catalog_builder.dart';
import 'wine_detail_screen.dart';
import 'winery_detail_screen.dart';

/// Карта виноделен + лента «рядом со мной» внизу.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _mapController = MapController();
  final MapStyle _style = defaultMapStyle;
  int? _selectedId;
  bool _locating = false;

  // Центр Молдовы — если виноделен пока нет
  static const _moldova = LatLng(47.0, 28.8);

  List<Winery> get _wineries => catalog.wineries;

  LatLng _point(Winery w) => LatLng(w.latitude, w.longitude);

  CameraFit? get _fitAll => _wineries.isEmpty
      ? null
      : CameraFit.bounds(
          bounds: LatLngBounds.fromPoints(_wineries.map(_point).toList()),
          padding: const EdgeInsets.all(56),
        );

  /// Винодельни: ближайшие сверху, если известно, где пользователь.
  List<Winery> _sorted(LatLng? me) {
    final list = [..._wineries];
    if (me == null) {
      list.sort((a, b) => a.name.compareTo(b.name));
    } else {
      list.sort(
        (a, b) => distanceKm(
          me,
          a.latitude,
          a.longitude,
        ).compareTo(distanceKm(me, b.latitude, b.longitude)),
      );
    }
    return list;
  }

  void _showAll() {
    final fit = _fitAll;
    if (fit != null) {
      _mapController.fitCamera(fit);
    } else {
      _mapController.move(_moldova, 7);
    }
  }

  Future<void> _locate() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _locating = true);
    final result = await locateUser();
    if (!mounted) return;
    setState(() => _locating = false);

    final me = userLocation.value;
    if (result == LocateResult.ok && me != null) {
      // Показываем себя и две ближайшие винодельни
      final nearest = _sorted(me).take(2).map(_point);
      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: LatLngBounds.fromPoints([me, ...nearest]),
          padding: const EdgeInsets.all(72),
          maxZoom: 12,
        ),
      );
      return;
    }

    final message = switch (result) {
      LocateResult.serviceDisabled => l10n.locationServiceOff,
      LocateResult.deniedForever => l10n.locationDeniedForever,
      LocateResult.denied => l10n.locationDenied,
      _ => l10n.locationFailed,
    };
    final canFix =
        result == LocateResult.serviceDisabled ||
        result == LocateResult.deniedForever;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          action: canFix
              ? SnackBarAction(
                  label: l10n.openSettings,
                  onPressed: () => openLocationSettingsFor(result),
                )
              : null,
        ),
      );
  }

  Future<void> _openWinery(Winery winery) async {
    setState(() => _selectedId = winery.id);
    _mapController.move(
      _point(winery),
      _mapController.camera.zoom < 10 ? 10 : _mapController.camera.zoom,
    );

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => _WinerySheet(winery: winery),
    );

    if (mounted) setState(() => _selectedId = null);
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CatalogBuilder(
      builder: (context, catalog) => ValueListenableBuilder<LatLng?>(
        valueListenable: userLocation,
        builder: (context, me, _) => Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCameraFit: _fitAll,
                      initialCenter: _moldova,
                      initialZoom: 7,
                      minZoom: 6,
                      maxZoom: 18,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: _style.url,
                        subdomains: _style.subdomains,
                        // Тайлы @2x на экранах высокой плотности — чётче
                        retinaMode:
                            _style.retina && RetinaMode.isHighDensity(context),
                        userAgentPackageName: 'md.wineexplorer.app',
                        tileBuilder: _style.tileBuilder,
                      ),
                      if (me != null)
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: me,
                              width: 44,
                              height: 44,
                              child: const _UserDot(),
                            ),
                          ],
                        ),
                      MarkerLayer(
                        markers: [
                          for (final winery in _wineries)
                            Marker(
                              point: _point(winery),
                              width: 48,
                              height: 48,
                              alignment: Alignment.topCenter,
                              child: _WineryPin(
                                selected: winery.id == _selectedId,
                                tooltip: winery.name,
                                onTap: () => _openWinery(winery),
                              ),
                            ),
                        ],
                      ),
                      // Атрибуция обязательна по правилам поставщиков карты
                      RichAttributionWidget(
                        // Справа — кнопки, атрибуция не должна быть под ними
                        alignment: AttributionAlignment.bottomLeft,
                        attributions: [
                          TextSourceAttribution(
                            _style.attribution,
                            onTap: () => launchUrl(
                              Uri.parse('https://openstreetmap.org/copyright'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: Column(
                      children: [
                        FloatingActionButton.small(
                          heroTag: 'locate',
                          tooltip: l10n.myLocation,
                          onPressed: _locating ? null : _locate,
                          child: _locating
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(
                                  me == null
                                      ? Icons.location_searching
                                      : Icons.my_location,
                                ),
                        ),
                        const SizedBox(height: 8),
                        FloatingActionButton.small(
                          heroTag: 'showAll',
                          tooltip: l10n.mapShowAll,
                          onPressed: _showAll,
                          child: const Icon(Icons.zoom_out_map),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _WineryStrip(
              wineries: _sorted(me),
              me: me,
              selectedId: _selectedId,
              onTap: _openWinery,
            ),
          ],
        ),
      ),
    );
  }
}

/// Лента виноделен под картой: ближайшие первыми.
class _WineryStrip extends StatelessWidget {
  final List<Winery> wineries;
  final LatLng? me;
  final int? selectedId;
  final ValueChanged<Winery> onTap;

  const _WineryStrip({
    required this.wineries,
    required this.me,
    required this.selectedId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (wineries.isEmpty) return const SizedBox.shrink();

    return Material(
      elevation: 8,
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
              child: Text(
                me == null ? l10n.mapWineriesTitle : l10n.nearMe,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.wineRed,
                ),
              ),
            ),
            SizedBox(
              height: 84,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                itemCount: wineries.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, i) {
                  final w = wineries[i];
                  final km = me == null
                      ? null
                      : distanceKm(me!, w.latitude, w.longitude);
                  final selected = w.id == selectedId;
                  return SizedBox(
                    width: 220,
                    child: Card(
                      margin: EdgeInsets.zero,
                      elevation: selected ? 4 : 1,
                      color: selected ? const Color(0xFFFAF0F2) : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: selected
                              ? AppTheme.wineRed
                              : const Color(0xFFE8C5CE),
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => onTap(w),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                w.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  if (km != null) ...[
                                    const Icon(
                                      Icons.near_me,
                                      size: 14,
                                      color: AppTheme.wineRed,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      l10n.distanceKm(formatKm(km)),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppTheme.wineRed,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  Expanded(
                                    child: Text(
                                      w.region ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Синяя точка «вы здесь».
class _UserDot extends StatelessWidget {
  const _UserDot();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF1A73E8).withValues(alpha: 0.18),
        ),
        alignment: Alignment.center,
        child: Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF1A73E8),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black26)],
          ),
        ),
      ),
    );
  }
}

/// Маркер винодельни: булавка с бокалом внутри.
class _WineryPin extends StatelessWidget {
  final bool selected;
  final String tooltip;
  final VoidCallback onTap;

  const _WineryPin({
    required this.selected,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppTheme.goldAccent : AppTheme.wineRed;
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          scale: selected ? 1.25 : 1.0,
          alignment: Alignment.bottomCenter,
          duration: const Duration(milliseconds: 150),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Icon(
                Icons.location_on,
                size: 48,
                color: color,
                shadows: const [Shadow(blurRadius: 6, color: Colors.black45)],
              ),
              const Positioned(
                top: 9,
                child: Icon(Icons.wine_bar, size: 17, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Нижняя панель с информацией о винодельне и её винами.
class _WinerySheet extends StatelessWidget {
  final Winery winery;

  const _WinerySheet({required this.winery});

  void _openRoute(BuildContext context) => openExternal(
    context,
    routeUri(winery.latitude, winery.longitude),
    errorText: AppLocalizations.of(context)!.mapRouteError,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final wines = catalog.winesOf(winery);

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    winery.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (winery.region != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.place, size: 16, color: Colors.grey[700]),
                        const SizedBox(width: 4),
                        Text(
                          winery.region!,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  Text(
                    l10n.mapWinesCount(wines.length),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            // Вина этой винодельни
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final wine in wines)
                    ListTile(
                      leading: const Icon(
                        Icons.wine_bar,
                        color: AppTheme.wineRed,
                      ),
                      title: Text(wine.name),
                      subtitle: Text(
                        [
                          localizedWineType(l10n, wine.type),
                          if (wine.hasVintage) '${wine.vintage}',
                        ].join(' • '),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WineDetailScreen(wine: wine),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              WineryDetailScreen(winery: winery),
                        ),
                      ),
                      icon: const Icon(Icons.info_outline),
                      label: Text(l10n.wineryMore),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _openRoute(context),
                      icon: const Icon(Icons.directions),
                      label: Text(l10n.mapRoute),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
