import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../l10n/wine_type_labels.dart';

import 'package:cached_network_image/cached_network_image.dart';

import '../core/favorites_controller.dart';
import '../data/mock_data.dart';
import '../models/wine.dart';
import 'wine_detail_screen.dart';

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
              : ValueListenableBuilder<Set<String>>(
                  valueListenable: favoriteWineIds,
                  builder: (context, favorites, _) => ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: filteredWines.length,
                    itemBuilder: (context, index) {
                      final wine = filteredWines[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  WineDetailScreen(wine: wine),
                            ),
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
                                    child: CachedNetworkImage(
                                      imageUrl: wine.imageUrl,
                                      width: 80,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.wine_bar, size: 50),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Инфо о вине
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          if (favorites.contains(wine.id))
                                            const Icon(
                                              Icons.favorite,
                                              color: Colors.redAccent,
                                              size: 18,
                                            ),
                                        ],
                                      ),
                                      Text(
                                        '${wine.wineryName} • ${wine.vintage}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                                '${wine.rating}',
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
                                              color: Color(0xFF58111A),
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
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
