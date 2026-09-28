import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/catalog_store.dart';
import '../l10n/app_localizations.dart';

/// Показывает загрузку или ошибку, пока каталог не готов, затем — [builder].
/// Без интернета, но с сохранённой копией — сверху плашка «Нет подключения».
class CatalogBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, CatalogStore catalog) builder;

  const CatalogBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: catalog,
      builder: (context, _) {
        if (catalog.hasData) {
          final content = builder(context, catalog);
          if (!catalog.isOffline) return content;
          return Column(
            children: [
              const _OfflineBanner(),
              Expanded(child: content),
            ],
          );
        }

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

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final updatedAt = catalog.updatedAt;
    final text = updatedAt == null
        ? l10n.offlineBannerNoDate
        : l10n.offlineBanner(
            DateFormat.MMMd(locale).add_Hm().format(updatedAt),
          );

    return Material(
      color: const Color(0xFFFFF4D6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
        child: Row(
          children: [
            const Icon(Icons.cloud_off, size: 20, color: Color(0xFF7A5B00)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 13, color: Color(0xFF5C4400)),
              ),
            ),
            catalog.isLoading
                ? const Padding(
                    padding: EdgeInsets.all(14),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : TextButton(onPressed: catalog.load, child: Text(l10n.retry)),
          ],
        ),
      ),
    );
  }
}
