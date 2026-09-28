import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../l10n/app_localizations.dart';
import '../models/grape.dart';
import '../widgets/catalog_builder.dart';
import 'grape_detail_screen.dart';

/// Справочник сортов: сначала местные, затем международные.
class GrapesScreen extends StatelessWidget {
  const GrapesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CatalogBuilder(
      builder: (context, catalog) {
        if (catalog.grapes.isEmpty) {
          return Center(child: Text(l10n.grapesEmpty));
        }
        final native = catalog.grapes.where((g) => g.isNative).toList();
        final international = catalog.grapes.where((g) => !g.isNative).toList();

        return RefreshIndicator(
          onRefresh: catalog.load,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              if (native.isNotEmpty) ...[
                _SectionHeader(l10n.grapesNative),
                for (final g in native)
                  _GrapeTile(
                    grape: g,
                    wineCount: catalog.winesOfGrape(g).length,
                  ),
              ],
              if (international.isNotEmpty) ...[
                _SectionHeader(l10n.grapesInternational),
                for (final g in international)
                  _GrapeTile(
                    grape: g,
                    wineCount: catalog.winesOfGrape(g).length,
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;

  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppTheme.wineRed,
        ),
      ),
    );
  }
}

/// Цветной кружок: бордовый — красный сорт, золотистый — белый.
class GrapeColorDot extends StatelessWidget {
  final Grape grape;
  final double size;

  const GrapeColorDot({super.key, required this.grape, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: grape.isRed
              ? const [Color(0xFF8B263E), Color(0xFF3E0A12)]
              : const [Color(0xFFF3E7B3), Color(0xFFC9B26A)],
        ),
      ),
      child: Icon(
        Icons.eco,
        size: size * 0.5,
        color: grape.isRed ? Colors.white70 : Colors.black45,
      ),
    );
  }
}

class _GrapeTile extends StatelessWidget {
  final Grape grape;
  final int wineCount;

  const _GrapeTile({required this.grape, required this.wineCount});

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final taste = grape.tasteFor(lang);

    return ListTile(
      leading: GrapeColorDot(grape: grape),
      title: Text(
        grape.name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: taste.isEmpty
          ? null
          : Text(taste, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (wineCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF0F2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wine_bar, size: 14, color: AppTheme.wineRed),
                  const SizedBox(width: 2),
                  Text(
                    '$wineCount',
                    style: const TextStyle(
                      color: AppTheme.wineRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GrapeDetailScreen(grape: grape),
        ),
      ),
    );
  }
}
