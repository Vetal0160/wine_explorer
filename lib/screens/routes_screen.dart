import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../core/location_controller.dart';
import '../core/theme.dart';
import '../data/catalog_store.dart';
import '../l10n/app_localizations.dart';
import '../models/wine_route.dart';
import '../models/winery.dart';
import '../widgets/catalog_builder.dart';
import 'route_detail_screen.dart';

/// Расстояние по прямой от предыдущей остановки, км (для первой — 0).
double legKm(List<Winery> stops, int i) => i == 0
    ? 0
    : distanceKm(
        LatLng(stops[i - 1].latitude, stops[i - 1].longitude),
        stops[i].latitude,
        stops[i].longitude,
      );

/// Суммарное расстояние между остановками по прямой, км.
double routeDistanceKm(List<Winery> stops) {
  var total = 0.0;
  for (var i = 1; i < stops.length; i++) {
    total += legKm(stops, i);
  }
  return total;
}

/// Список винных маршрутов.
class RoutesScreen extends StatelessWidget {
  const RoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.wineRoutes)),
      body: CatalogBuilder(
        builder: (context, catalog) {
          final routes = catalog.visibleRoutes;
          if (routes.isEmpty) return Center(child: Text(l10n.routesEmpty));
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [for (final r in routes) RouteCard(route: r)],
          );
        },
      ),
    );
  }
}

/// Карточка маршрута: название, остановки, продолжительность, расстояние.
class RouteCard extends StatelessWidget {
  final WineRoute route;

  const RouteCard({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;
    final stops = catalog.stopsOf(route);
    final km = routeDistanceKm(stops);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RouteDetailScreen(route: route),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.route, color: AppTheme.wineRed),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      route.titleFor(lang),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                stops.map((w) => w.name).join('  →  '),
                style: TextStyle(color: Colors.grey[800], height: 1.4),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  if (route.durationFor(lang).isNotEmpty)
                    _Tag(Icons.schedule, route.durationFor(lang)),
                  _Tag(Icons.place_outlined, l10n.routeStops(stops.length)),
                  if (km > 0)
                    _Tag(Icons.straighten, l10n.routeDistance(formatKm(km))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Tag(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF0F2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.wineRed),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 13, color: AppTheme.wineRed),
          ),
        ],
      ),
    );
  }
}
