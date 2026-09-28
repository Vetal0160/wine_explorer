import 'package:flutter/material.dart';

import '../core/external_links.dart';
import '../core/theme.dart';
import '../data/catalog_store.dart';
import '../l10n/app_localizations.dart';
import '../models/winery.dart';
import '../widgets/wine_card.dart';
import '../widgets/wine_image.dart';

/// Страница винодельни: описание, дегустации, контакты и её вина.
class WineryDetailScreen extends StatelessWidget {
  final Winery winery;

  const WineryDetailScreen({super.key, required this.winery});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;
    final description = winery.descriptionFor(lang);
    final hours = winery.hoursFor(lang);
    final wines = catalog.winesOf(winery);
    final errorText = l10n.openError;

    final infoTiles = <Widget>[
      if (winery.hasTastings != null)
        _InfoTile(
          icon: Icons.wine_bar,
          title: l10n.wineryTastings,
          value: [
            winery.hasTastings!
                ? l10n.wineryTastingsYes
                : l10n.wineryTastingsNo,
            if (winery.hasTastings! && winery.tastingPriceLei != null)
              l10n.wineryTastingFrom(winery.tastingPriceLei!.round()),
            if (winery.hasTastings! && winery.bookingRequired == true)
              l10n.wineryBookingRequired,
          ].join(' · '),
        ),
      if (hours.isNotEmpty)
        _InfoTile(icon: Icons.schedule, title: l10n.wineryHours, value: hours),
      _InfoTile(
        icon: Icons.place_outlined,
        title: l10n.wineryAddress,
        value: winery.address ?? winery.region ?? winery.name,
        action: Icons.directions,
        onTap: () => openExternal(
          context,
          routeUri(winery.latitude, winery.longitude),
          errorText: l10n.mapRouteError,
        ),
      ),
      if (winery.phone != null)
        _InfoTile(
          icon: Icons.phone_outlined,
          title: l10n.wineryPhone,
          value: winery.phone!,
          action: Icons.call,
          onTap: () => openExternal(
            context,
            phoneUri(winery.phone!),
            errorText: errorText,
          ),
        ),
      if (winery.website != null)
        _InfoTile(
          icon: Icons.language,
          title: l10n.wineryWebsite,
          value: prettyWebsite(winery.website!),
          action: Icons.open_in_new,
          onTap: () => openExternal(
            context,
            websiteUri(winery.website!),
            errorText: errorText,
          ),
        ),
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                winery.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  WineImage(
                    imageUrl: winery.imageUrl,
                    wineType: 'red_dry',
                    iconSize: 80,
                    placeholderIcon: Icons.castle_outlined,
                  ),
                  // Затемнение, чтобы название читалось на любом фото
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black26,
                          Colors.transparent,
                          Colors.black54,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            sliver: SliverList.list(
              children: [
                if (winery.region != null)
                  Text(
                    [
                      winery.region!,
                      if (winery.foundedYear != null)
                        l10n.wineryFounded(winery.foundedYear!),
                    ].join(' · '),
                    style: TextStyle(color: Colors.grey[700], fontSize: 15),
                  ),
                const SizedBox(height: 16),
                Text(
                  l10n.wineryAbout,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description.isNotEmpty ? description : l10n.wineryNoInfo,
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 16),
                Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      for (var i = 0; i < infoTiles.length; i++) ...[
                        if (i > 0) const Divider(height: 1, indent: 56),
                        infoTiles[i],
                      ],
                    ],
                  ),
                ),
                if (wines.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    l10n.wineryWines,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.wineRed,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
            sliver: SliverList.builder(
              itemCount: wines.length,
              itemBuilder: (context, index) => WineCard(wine: wines[index]),
            ),
          ),
        ],
      ),
    );
  }
}

/// Строка «иконка — заголовок/значение — действие».
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final IconData? action;
  final VoidCallback? onTap;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
    this.action,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.wineRed),
      title: Text(
        title,
        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 15, color: Colors.black87),
      ),
      trailing: action == null
          ? null
          : Icon(action, color: AppTheme.wineRed, size: 20),
      onTap: onTap,
    );
  }
}
