import 'package:flutter/material.dart';

import '../core/age_gate_controller.dart';
import '../core/theme.dart';
import '../l10n/app_localizations.dart';
import '../widgets/language_menu_button.dart';

/// Первый запуск: подтверждение, что пользователю есть 18 лет.
class AgeGateScreen extends StatefulWidget {
  const AgeGateScreen({super.key});

  @override
  State<AgeGateScreen> createState() => _AgeGateScreenState();
}

class _AgeGateScreenState extends State<AgeGateScreen> {
  bool _denied = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const textColor = Colors.white;
    final mutedColor = Colors.white.withValues(alpha: 0.75);

    return Scaffold(
      backgroundColor: AppTheme.wineRed,
      body: SafeArea(
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topRight,
              child: LanguageMenuButton(color: textColor),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/icon/splash.png',
                        width: 120,
                        height: 120,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _denied ? l10n.ageDeniedTitle : l10n.ageTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _denied ? l10n.ageDeniedText : l10n.ageText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: mutedColor,
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 32),
                      if (_denied)
                        OutlinedButton(
                          onPressed: () => setState(() => _denied = false),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: textColor,
                            side: const BorderSide(color: Colors.white54),
                            minimumSize: const Size.fromHeight(52),
                          ),
                          child: Text(l10n.ageBack),
                        )
                      else ...[
                        FilledButton(
                          onPressed: confirmAge,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.goldAccent,
                            foregroundColor: AppTheme.wineRed,
                            minimumSize: const Size.fromHeight(52),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: Text(l10n.ageYes),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => setState(() => _denied = true),
                          style: TextButton.styleFrom(
                            foregroundColor: textColor,
                            minimumSize: const Size.fromHeight(48),
                          ),
                          child: Text(l10n.ageNo),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
              child: Text(
                l10n.ageHealthWarning,
                textAlign: TextAlign.center,
                style: TextStyle(color: mutedColor, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
