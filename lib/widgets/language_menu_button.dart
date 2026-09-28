import 'package:flutter/material.dart';

import '../core/locale_controller.dart';
import '../l10n/app_localizations.dart';

/// Кнопка 🌐 с выбором языка приложения.
class LanguageMenuButton extends StatelessWidget {
  final Color? color;

  const LanguageMenuButton({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopupMenuButton<String>(
      icon: Icon(Icons.language, color: color),
      tooltip: l10n.language,
      onSelected: setAppLocale,
      itemBuilder: (context) => [
        for (final entry in supportedLanguages.entries)
          CheckedPopupMenuItem(
            value: entry.key,
            checked: Localizations.localeOf(context).languageCode == entry.key,
            child: Text(entry.value),
          ),
      ],
    );
  }
}
