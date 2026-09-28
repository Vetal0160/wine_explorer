import 'package:flutter/material.dart';

import '../core/favorites_controller.dart';
import '../core/theme.dart';
import '../l10n/app_localizations.dart';
import '../l10n/wine_type_labels.dart';
import '../models/wine.dart';
import '../widgets/wine_image.dart';

/// Детальная карточка вина.
class WineDetailScreen extends StatelessWidget {
  final Wine wine;

  const WineDetailScreen({super.key, required this.wine});

  Future<void> _toggleFavorite(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final added = await toggleFavorite(wine.id);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(added ? l10n.favoriteAdded : l10n.favoriteRemoved),
          duration: const Duration(seconds: 1),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final languageCode = Localizations.localeOf(context).languageCode;

    // Перестраиваем экран при изменении избранного
    return ValueListenableBuilder<Set<String>>(
      valueListenable: favoriteWineIds,
      builder: (context, favorites, _) {
        final favorite = favorites.contains(wine.id);

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // Плавающая шапка с изображением
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'wine-image-${wine.id}',
                        child: WineImage(
                          imageUrl: wine.imageUrl,
                          wineType: wine.type,
                          iconSize: 96,
                        ),
                      ),
                      // Затемнение сверху, чтобы кнопки были видны на светлом фото
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.center,
                            colors: [Colors.black54, Colors.transparent],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    tooltip: favorite ? l10n.favoriteRemove : l10n.favoriteAdd,
                    icon: Icon(
                      favorite ? Icons.favorite : Icons.favorite_border,
                      color: favorite ? Colors.redAccent : Colors.white,
                    ),
                    onPressed: () => _toggleFavorite(context),
                  ),
                ],
              ),

              // Контентная часть
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Название и рейтинг
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              wine.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          _RatingBadge(rating: wine.rating),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${wine.wineryName} • ${l10n.vintageYear(wine.vintage)}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Тэги (тип, сорт, цена)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Chip(
                            avatar: const Icon(Icons.wine_bar, size: 16),
                            label: Text(localizedWineType(l10n, wine.type)),
                          ),
                          if (wine.grapeVariety.isNotEmpty)
                            Chip(
                              avatar: const Icon(Icons.local_florist, size: 16),
                              label: Text(wine.grapeVariety),
                            ),
                          Chip(
                            backgroundColor: AppTheme.wineRed,
                            label: Text(
                              '~${l10n.priceLdl(wine.priceLei.round())}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 12),

                      // Описание
                      Text(
                        l10n.detailTasting,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        wine.descriptionFor(languageCode).isNotEmpty
                            ? wine.descriptionFor(languageCode)
                            : l10n.noDescription,
                        style: textTheme.bodyLarge?.copyWith(height: 1.5),
                      ),

                      const SizedBox(height: 24),

                      // Гастрономическая пара
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAF0F2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE8C5CE)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.restaurant,
                                  color: AppTheme.wineRed,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.detailPairing,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.wineRed,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              localizedPairing(l10n, wine.type),
                              style: const TextStyle(fontSize: 14, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Кнопка «Добавить в мой подвал»
          bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: favorite
                ? OutlinedButton.icon(
                    onPressed: () => _toggleFavorite(context),
                    icon: const Icon(Icons.favorite),
                    label: Text(l10n.favoriteRemove),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                  )
                : FilledButton.icon(
                    onPressed: () => _toggleFavorite(context),
                    icon: const Icon(Icons.favorite_border),
                    label: Text(l10n.favoriteAdd),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final double rating;

  const _RatingBadge({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 20),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
