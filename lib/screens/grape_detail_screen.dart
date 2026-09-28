import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../data/catalog_store.dart';
import '../l10n/app_localizations.dart';
import '../models/grape.dart';
import '../widgets/wine_card.dart';
import '../widgets/wine_image.dart';

/// Страница сорта: описание, вкус и вина из него.
class GrapeDetailScreen extends StatelessWidget {
  final Grape grape;

  const GrapeDetailScreen({super.key, required this.grape});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;
    final description = grape.descriptionFor(lang);
    final taste = grape.tasteFor(lang);
    final wines = catalog.winesOfGrape(grape);
    const headingStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                grape.name,
                style: TextStyle(
                  color: grape.isRed ? Colors.white : AppTheme.wineRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: WineImage(
                imageUrl: grape.imageUrl,
                wineType: grape.isRed ? 'red_dry' : 'white_dry',
                iconSize: 80,
                placeholderIcon: Icons.eco,
              ),
            ),
            // Тёмные значки на светлом фоне белого сорта
            foregroundColor: grape.isRed ? Colors.white : AppTheme.wineRed,
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            sliver: SliverList.list(
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(
                      avatar: Icon(
                        Icons.circle,
                        size: 14,
                        color: grape.isRed
                            ? AppTheme.wineRed
                            : const Color(0xFFC9B26A),
                      ),
                      label: Text(
                        grape.isRed ? l10n.grapeRed : l10n.grapeWhite,
                      ),
                    ),
                    if (grape.isNative)
                      Chip(
                        avatar: const Icon(Icons.flag_outlined, size: 16),
                        label: Text(l10n.grapeNativeBadge),
                      ),
                  ],
                ),
                if (grape.aliases.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    l10n.grapeAliases(grape.aliases.join(', ')),
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(l10n.grapeAbout, style: headingStyle),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(height: 1.5),
                  ),
                ],
                if (taste.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Container(
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
                              Icons.local_florist,
                              color: AppTheme.wineRed,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.grapeTaste,
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
                          taste,
                          style: const TextStyle(fontSize: 15, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Text(
                  l10n.grapeWines,
                  style: headingStyle.copyWith(color: AppTheme.wineRed),
                ),
                const SizedBox(height: 8),
                if (wines.isEmpty)
                  Text(
                    l10n.grapeNoWines,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
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
