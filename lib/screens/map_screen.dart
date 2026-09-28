import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/theme.dart';
import '../data/catalog_store.dart';
import '../l10n/app_localizations.dart';
import '../l10n/wine_type_labels.dart';
import '../models/winery.dart';
import '../widgets/catalog_builder.dart';
import 'wine_detail_screen.dart';

/// Карта виноделен (OpenStreetMap, ключ API не нужен).
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _mapController = MapController();
  int? _selectedId;

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

  void _showAll() {
    final fit = _fitAll;
    if (fit != null) {
      _mapController.fitCamera(fit);
    } else {
      _mapController.move(_moldova, 7);
    }
  }

  Future<void> _openWinery(Winery winery) async {
    setState(() => _selectedId = winery.id);
    _mapController.move(_point(winery), _mapController.camera.zoom);

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

    return Scaffold(
      body: CatalogBuilder(
        builder: (context, catalog) => FlutterMap(
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
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'md.wineexplorer.app',
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
            // Атрибуция обязательна по правилам OpenStreetMap
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => launchUrl(
                    Uri.parse('https://openstreetmap.org/copyright'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        tooltip: l10n.mapShowAll,
        onPressed: _showAll,
        child: const Icon(Icons.zoom_out_map),
      ),
    );
  }
}

/// Маркер винодельни на карте.
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
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          scale: selected ? 1.3 : 1.0,
          alignment: Alignment.bottomCenter,
          duration: const Duration(milliseconds: 150),
          child: Icon(
            Icons.location_on,
            size: 48,
            color: selected ? AppTheme.goldAccent : AppTheme.wineRed,
            shadows: const [Shadow(blurRadius: 4, color: Colors.black38)],
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

  Future<void> _openRoute(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=${winery.latitude},${winery.longitude}',
    );
    bool ok;
    try {
      ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      ok = false;
    }
    if (!ok) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.mapRouteError)));
    }
  }

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
                        '${localizedWineType(l10n, wine.type)} • ${wine.vintage}',
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
    );
  }
}
