import 'package:flutter/material.dart';

import '../data/wine_filter.dart';
import '../l10n/app_localizations.dart';
import '../models/wine.dart';

/// Панель фильтров (цена, винодельни). Возвращает новый фильтр или null.
Future<WineFilter?> showWineFilterSheet(
  BuildContext context, {
  required WineFilter filter,
  required List<Wine> wines,
}) {
  return showModalBottomSheet<WineFilter>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => _WineFilterSheet(initial: filter, wines: wines),
  );
}

class _WineFilterSheet extends StatefulWidget {
  final WineFilter initial;
  final List<Wine> wines;

  const _WineFilterSheet({required this.initial, required this.wines});

  @override
  State<_WineFilterSheet> createState() => _WineFilterSheetState();
}

class _WineFilterSheetState extends State<_WineFilterSheet> {
  late WineFilter _filter = widget.initial;
  late final PriceRange _bounds = priceBounds(widget.wines);

  late final List<String> _wineryNames =
      widget.wines.map((w) => w.wineryName).toSet().toList()..sort();

  void _toggleWinery(String name) {
    final wineries = {..._filter.wineries};
    if (!wineries.remove(name)) wineries.add(name);
    setState(() => _filter = _filter.copyWith(wineries: wineries));
  }

  void _setPrice(RangeValues values) {
    final full = values.start <= _bounds.min && values.end >= _bounds.max;
    setState(
      () => _filter = full
          ? _filter.copyWith(clearPrice: true)
          : _filter.copyWith(price: PriceRange(values.start, values.end)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final price = _filter.price ?? _bounds;
    final count = _filter.apply(widget.wines).length;
    final showPrice = _bounds.max > _bounds.min;
    const titleStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  Text(
                    l10n.filters,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (showPrice) ...[
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.filterPrice, style: titleStyle),
                        Text(
                          '${l10n.priceLdl(price.min.round())} – '
                          '${l10n.priceLdl(price.max.round())}',
                        ),
                      ],
                    ),
                    RangeSlider(
                      min: _bounds.min,
                      max: _bounds.max,
                      // Шаг 10 леев
                      divisions: ((_bounds.max - _bounds.min) / 10).round(),
                      values: RangeValues(price.min, price.max),
                      onChanged: _setPrice,
                    ),
                  ],
                  const SizedBox(height: 12),
                  Text(l10n.filterWineries, style: titleStyle),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final name in _wineryNames)
                        FilterChip(
                          label: Text(name),
                          selected: _filter.wineries.contains(name),
                          onSelected: (_) => _toggleWinery(name),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => setState(() => _filter = _filter.cleared),
                    child: Text(l10n.filterReset),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context, _filter),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: Text(l10n.filterShow(count)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
