import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../data/dishes.dart';
import '../data/catalog_store.dart';
import '../l10n/app_localizations.dart';
import '../l10n/dish_labels.dart';
import '../models/wine.dart';
import '../widgets/catalog_builder.dart';
import '../widgets/wine_card.dart';

/// Подбор вина под блюдо.
class PairingScreen extends StatefulWidget {
  const PairingScreen({super.key});

  @override
  State<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {
  Dish _selected = Dish.placinte;

  /// Подходящие вина: сначала предпочтительный тип, внутри — по рейтингу.
  List<Wine> _matchesFor(Dish dish) {
    final matches = catalog.wines
        .where((w) => dish.wineTypes.contains(w.type))
        .toList();
    matches.sort((a, b) {
      final byType = dish.wineTypes
          .indexOf(a.type)
          .compareTo(dish.wineTypes.indexOf(b.type));
      return byType != 0 ? byType : b.rating.compareTo(a.rating);
    });
    return matches;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CatalogBuilder(
      builder: (context, catalog) {
        final matches = _matchesFor(_selected);

        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Text(
              l10n.pairingQuestion,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Выбор блюда
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final dish in Dish.values)
                  ChoiceChip(
                    avatar: Text(dish.emoji),
                    label: Text(localizedDishName(l10n, dish)),
                    selected: dish == _selected,
                    showCheckmark: false,
                    onSelected: (_) => setState(() => _selected = dish),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Почему такие вина
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF0F2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8C5CE)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_selected.emoji, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      localizedDishReason(l10n, _selected),
                      style: const TextStyle(fontSize: 14, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text(
              l10n.pairingMatches,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.wineRed,
              ),
            ),
            const SizedBox(height: 8),
            if (matches.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(child: Text(l10n.pairingNoMatches)),
              )
            else
              for (final wine in matches) WineCard(wine: wine),
          ],
        );
      },
    );
  }
}
