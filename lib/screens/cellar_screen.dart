import 'package:flutter/material.dart';

import '../core/favorites_controller.dart';
import '../core/theme.dart';
import '../l10n/app_localizations.dart';
import '../widgets/catalog_builder.dart';
import '../widgets/wine_card.dart';

/// «Мой подвал» — избранные вина.
class CellarScreen extends StatelessWidget {
  /// Переход в каталог из пустого состояния.
  final VoidCallback onBrowse;

  const CellarScreen({super.key, required this.onBrowse});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CatalogBuilder(
      builder: (context, catalog) => ValueListenableBuilder<Set<String>>(
        valueListenable: favoriteWineIds,
        builder: (context, favorites, _) {
          final wines = catalog.wines
              .where((w) => favorites.contains(w.id))
              .toList();

          if (wines.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.wine_bar, size: 72, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      l10n.cellarEmptyTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.cellarEmptyHint,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: onBrowse,
                      icon: const Icon(Icons.search),
                      label: Text(l10n.cellarBrowse),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.wineRed,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [for (final wine in wines) WineCard(wine: wine)],
          );
        },
      ),
    );
  }
}
