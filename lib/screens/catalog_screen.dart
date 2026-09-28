import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../data/mock_data.dart';
import '../models/wine.dart';
import '../widgets/wine_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  // Тестовые данные (позже будут загружаться с вашего API)
  final List<Wine> _wines = mockWines;

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filteredWines = _wines.where((wine) {
      return wine.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          wine.wineryName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

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
          child: filteredWines.isEmpty
              ? Center(child: Text(l10n.noResults))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: filteredWines.length,
                  itemBuilder: (context, index) =>
                      WineCard(wine: filteredWines[index]),
                ),
        ),
      ],
    );
  }
}
