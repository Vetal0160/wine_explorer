import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../widgets/catalog_builder.dart';
import '../widgets/wine_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Поисковая строка
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: l10n.searchHint,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),

        // Список вин
        Expanded(
          child: CatalogBuilder(
            builder: (context, catalog) {
              final query = _searchQuery.toLowerCase();
              final filteredWines = catalog.wines.where((wine) {
                return wine.name.toLowerCase().contains(query) ||
                    wine.wineryName.toLowerCase().contains(query);
              }).toList();

              // Потянуть список вниз — перезагрузить каталог
              return RefreshIndicator(
                onRefresh: catalog.load,
                child: filteredWines.isEmpty
                    ? ListView(
                        children: [
                          const SizedBox(height: 80),
                          Center(child: Text(l10n.noResults)),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: filteredWines.length,
                        itemBuilder: (context, index) =>
                            WineCard(wine: filteredWines[index]),
                      ),
              );
            },
          ),
        ),
      ],
    );
  }
}
