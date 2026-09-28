import 'package:flutter/material.dart';

import '../data/catalog_store.dart';
import '../data/wine_filter.dart';
import '../l10n/app_localizations.dart';
import '../l10n/wine_type_labels.dart';
import '../widgets/catalog_builder.dart';
import '../widgets/wine_card.dart';
import '../widgets/wine_filter_sheet.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final _searchController = TextEditingController();
  WineFilter _filter = const WineFilter();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleType(String type) {
    final types = {..._filter.types};
    if (!types.remove(type)) types.add(type);
    setState(() => _filter = _filter.copyWith(types: types));
  }

  Future<void> _openFilters(CatalogStore catalog) async {
    final result = await showWineFilterSheet(
      context,
      filter: _filter,
      wines: catalog.wines,
    );
    if (result != null) setState(() => _filter = result);
  }

  void _resetAll() {
    _searchController.clear();
    setState(() => _filter = WineFilter(sort: _filter.sort));
  }

  String _sortLabel(AppLocalizations l10n, WineSort sort) => switch (sort) {
    WineSort.rating => l10n.sortRating,
    WineSort.priceAsc => l10n.sortPriceAsc,
    WineSort.priceDesc => l10n.sortPriceDesc,
    WineSort.vintage => l10n.sortVintage,
    WineSort.name => l10n.sortName,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Поисковая строка
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: TextField(
            controller: _searchController,
            onChanged: (value) =>
                setState(() => _filter = _filter.copyWith(query: value)),
            decoration: InputDecoration(
              hintText: l10n.searchHint,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _filter.query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: l10n.clearSearch,
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _filter = _filter.copyWith(query: ''));
                      },
                    ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),

        Expanded(
          child: CatalogBuilder(
            builder: (context, catalog) {
              final wines = _filter.apply(catalog.wines);
              // Цена и винодельни — в панели; типы видны чипами отдельно
              final sheetFilters =
                  _filter.activeCount - (_filter.types.isNotEmpty ? 1 : 0);

              return Column(
                children: [
                  // Кнопка фильтров + быстрый выбор типа вина
                  SizedBox(
                    height: 48,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: [
                        Center(
                          child: Badge(
                            isLabelVisible: sheetFilters > 0,
                            label: Text('$sheetFilters'),
                            child: ActionChip(
                              avatar: const Icon(Icons.tune, size: 18),
                              label: Text(l10n.filters),
                              onPressed: () => _openFilters(catalog),
                            ),
                          ),
                        ),
                        for (final type in wineTypeCodes) ...[
                          const SizedBox(width: 8),
                          Center(
                            child: FilterChip(
                              label: Text(localizedWineType(l10n, type)),
                              selected: _filter.types.contains(type),
                              onSelected: (_) => _toggleType(type),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Сколько найдено + сортировка
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 4, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.filterResults(wines.length),
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        PopupMenuButton<WineSort>(
                          tooltip: l10n.sortBy,
                          initialValue: _filter.sort,
                          onSelected: (sort) => setState(
                            () => _filter = _filter.copyWith(sort: sort),
                          ),
                          itemBuilder: (context) => [
                            for (final sort in WineSort.values)
                              CheckedPopupMenuItem(
                                value: sort,
                                checked: sort == _filter.sort,
                                child: Text(_sortLabel(l10n, sort)),
                              ),
                          ],
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.sort, size: 18),
                                const SizedBox(width: 4),
                                Text(_sortLabel(l10n, _filter.sort)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Список вин; потянуть вниз — перезагрузить каталог
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: catalog.load,
                      child: wines.isEmpty
                          ? ListView(
                              children: [
                                const SizedBox(height: 80),
                                Center(child: Text(l10n.noResults)),
                                if (_filter.activeCount > 0 ||
                                    _filter.query.isNotEmpty)
                                  Center(
                                    child: TextButton(
                                      onPressed: _resetAll,
                                      child: Text(l10n.filterReset),
                                    ),
                                  ),
                              ],
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                              itemCount: wines.length,
                              itemBuilder: (context, index) =>
                                  WineCard(wine: wines[index]),
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
