import 'package:flutter/material.dart';

import '../data/catalog_store.dart';
import '../l10n/app_localizations.dart';

/// Показывает загрузку или ошибку, пока каталог не готов, затем — [builder].
class CatalogBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, CatalogStore catalog) builder;

  const CatalogBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: catalog,
      builder: (context, _) {
        if (catalog.hasData) return builder(context, catalog);

        if (catalog.error != null && !catalog.isLoading) {
          final l10n = AppLocalizations.of(context)!;
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cloud_off, size: 64, color: Colors.grey[500]),
                  const SizedBox(height: 16),
                  Text(l10n.loadError, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: catalog.load,
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.retry),
                  ),
                ],
              ),
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
