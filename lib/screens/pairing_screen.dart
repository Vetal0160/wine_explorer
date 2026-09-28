import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// Подбор еды и вина.
class PairingScreen extends StatelessWidget {
  const PairingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Text('🥖 ${l10n.pairingPlaceholder}', style: const TextStyle(fontSize: 20)),
    );
  }
}
