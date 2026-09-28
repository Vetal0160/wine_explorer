import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../core/external_links.dart';
import '../core/location_controller.dart';
import '../core/map_style.dart';
import '../core/share.dart';
import '../core/theme.dart';
import '../data/catalog_store.dart';
import '../l10n/app_localizations.dart';
import '../models/wine_route.dart';
import '../models/winery.dart';
import 'routes_screen.dart';
import 'winery_detail_screen.dart';

/// Страница маршрута: карта с остановками, описание, список, Google Карты.
class RouteDetailScreen extends StatelessWidget {
  final WineRoute route;

  const RouteDetailScreen({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;
    final stops = catalog.stopsOf(route);
    final points = [for (final w in stops) LatLng(w.latitude, w.longitude)];
    final km = routeDistanceKm(stops);
    final style = defaultMapStyle;

    return Scaffold(
      appBar: AppBar(
        title: Text(route.titleFor(lang)),
        actions: [
          Builder(
            builder: (context) => IconButton(
              tooltip: l10n.share,
              icon: const Icon(Icons.share),
              onPressed: () => shareText(
                context,
                routeShareText(l10n, route, stops, lang),
                subject: route.titleFor(lang),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          // Мини-карта: остановки по номерам, соединённые линией
          SizedBox(
            height: 260,
            child: FlutterMap(
              options: MapOptions(
                initialCameraFit: CameraFit.bounds(
                  bounds: LatLngBounds.fromPoints(points),
                  padding: const EdgeInsets.all(40),
                  maxZoom: 13,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: style.url,
                  subdomains: style.subdomains,
                  retinaMode: style.retina && RetinaMode.isHighDensity(context),
                  userAgentPackageName: 'md.wineexplorer.app',
                  tileBuilder: style.tileBuilder,
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: points,
                      strokeWidth: 4,
                      color: AppTheme.wineRed.withValues(alpha: 0.7),
                      pattern: StrokePattern.dashed(segments: const [12, 8]),
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    for (var i = 0; i < points.length; i++)
                      Marker(
                        point: points[i],
                        width: 30,
                        height: 30,
                        child: _StopNumber(i + 1),
                      ),
                  ],
                ),
                RichAttributionWidget(
                  alignment: AttributionAlignment.bottomLeft,
                  attributions: [TextSourceAttribution(style.attribution)],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 16,
                  runSpacing: 6,
                  children: [
                    if (route.durationFor(lang).isNotEmpty)
                      _Info(Icons.schedule, route.durationFor(lang)),
                    _Info(Icons.place_outlined, l10n.routeStops(stops.length)),
                    if (km > 0)
                      _Info(Icons.straighten, l10n.routeDistance(formatKm(km))),
                  ],
                ),
                if (route.descriptionFor(lang).isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    route.descriptionFor(lang),
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(height: 1.5),
                  ),
                ],
                const SizedBox(height: 16),
                // Трезвый водитель — для приложения о вине это важно
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF4D6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.local_taxi, color: Color(0xFF7A5B00)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${l10n.routeDriverNote}\n${l10n.routeCheckHours}',
                          style: const TextStyle(
                            color: Color(0xFF5C4400),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.routeStopsTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.wineRed,
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          for (var i = 0; i < stops.length; i++)
            _StopTile(index: i, stops: stops, lang: lang),
          const SizedBox(height: 90),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: FilledButton.icon(
          onPressed: () => openExternal(
            context,
            routeWithStopsUri([
              for (final w in stops) (lat: w.latitude, lng: w.longitude),
            ]),
            errorText: l10n.mapRouteError,
          ),
          icon: const Icon(Icons.directions),
          label: Text(l10n.routeOpenInMaps),
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
        ),
      ),
    );
  }
}

/// Текст для «Поделиться» маршрутом.
String routeShareText(
  AppLocalizations l10n,
  WineRoute route,
  List<Winery> stops,
  String lang,
) {
  final uri = routeWithStopsUri([
    for (final w in stops) (lat: w.latitude, lng: w.longitude),
  ]);
  return [
    '🍷 ${route.titleFor(lang)}',
    if (route.durationFor(lang).isNotEmpty) route.durationFor(lang),
    '',
    for (var i = 0; i < stops.length; i++) '${i + 1}. ${stops[i].name}',
    '',
    '📍 $uri',
    '',
    l10n.shareFooter,
  ].join('\n');
}

class _StopNumber extends StatelessWidget {
  final int number;

  const _StopNumber(this.number);

  @override
  Widget build(BuildContext context) {
    // Размер задаём явно: в ListTile.leading без него кружок растягивается
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.wineRed,
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black38)],
      ),
      alignment: Alignment.center,
      child: Text(
        '$number',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Info(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppTheme.wineRed),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

/// Остановка: номер, название, расстояние от предыдущей, часы и дегустации.
class _StopTile extends StatelessWidget {
  final int index;
  final List<Winery> stops;
  final String lang;

  const _StopTile({
    required this.index,
    required this.stops,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final w = stops[index];
    final hours = w.hoursFor(lang);
    final details = [
      if (index > 0) l10n.routeFromPrevious(formatKm(legKm(stops, index))),
      if (hours.isNotEmpty) hours,
      if (w.hasTastings == true && w.tastingPriceLei != null)
        '${l10n.wineryTastings}: ${l10n.wineryTastingFrom(w.tastingPriceLei!.round())}',
    ];

    return ListTile(
      leading: _StopNumber(index + 1),
      title: Text(w.name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        [if (w.region != null) w.region!, ...details].join('\n'),
        style: const TextStyle(height: 1.4),
      ),
      isThreeLine: details.isNotEmpty,
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WineryDetailScreen(winery: w)),
      ),
    );
  }
}
