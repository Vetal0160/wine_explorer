import 'package:flutter/material.dart';

import '../core/favorites_controller.dart';
import '../core/theme.dart';
import '../l10n/app_localizations.dart';
import '../l10n/wine_type_labels.dart';
import '../models/wine.dart';
import '../screens/wine_detail_screen.dart';
import 'wine_image.dart';

/// Карточка вина в списке. По нажатию открывает детальный экран.
class WineCard extends StatelessWidget {
  final Wine wine;

  const WineCard({super.key, required this.wine});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WineDetailScreen(wine: wine)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Картинка бутылки
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Hero(
                  tag: 'wine-image-${wine.id}',
                  child: WineImage(
                    imageUrl: wine.imageUrl,
                    wineType: wine.type,
                    width: 80,
                    height: 100,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Инфо о вине
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            wine.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ValueListenableBuilder<Set<String>>(
                          valueListenable: favoriteWineIds,
                          builder: (context, favorites, _) =>
                              favorites.contains(wine.id)
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.redAccent,
                                  size: 18,
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                    Text(
                      '${wine.wineryName} • ${wine.vintage}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 6),
                    Chip(
                      label: Text(
                        localizedWineType(l10n, wine.type),
                        style: const TextStyle(fontSize: 11),
                      ),
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              wine.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '~${l10n.priceLdl(wine.priceLei.round())}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.wineRed,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
