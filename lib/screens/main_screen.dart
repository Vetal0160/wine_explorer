import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../data/catalog_store.dart';
import 'catalog_screen.dart';
import 'cellar_screen.dart';
import 'grapes_screen.dart';
import 'map_screen.dart';
import 'pairing_screen.dart';
import '../widgets/language_menu_button.dart';
import '../core/external_links.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Вернулись в приложение, а данные устаревшие — пробуем обновить
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && catalog.isOffline) {
      catalog.load();
    }
  }

  void _showAbout(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showAboutDialog(
      context: context,
      applicationName: l10n.appTitle,
      applicationIcon: Image.asset(
        'assets/icon/splash.png',
        width: 48,
        height: 48,
      ),
      applicationLegalese: '© 2026 Vitali Ermisco',
      children: [
        const SizedBox(height: 16),
        Text(l10n.aboutText),
        const SizedBox(height: 8),
        Text(l10n.ageHealthWarning, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => openExternal(
              context,
              Uri.parse(privacyPolicyUrl),
              errorText: l10n.openError,
            ),
            icon: const Icon(Icons.privacy_tip_outlined),
            label: Text(l10n.privacyPolicy),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            tooltip: l10n.about,
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showAbout(context),
          ),
          const LanguageMenuButton(),
        ],
      ),
      body: switch (_currentIndex) {
        0 => const CatalogScreen(),
        1 => const MapScreen(),
        2 => const PairingScreen(),
        3 => const GrapesScreen(),
        _ => CellarScreen(onBrowse: () => setState(() => _currentIndex = 0)),
      },
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        // С 4 вкладками по умолчанию включается shifting-режим с белыми иконками
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.wine_bar),
            label: l10n.tabWines,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.map_outlined),
            label: l10n.tabMap,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.restaurant_menu),
            label: l10n.tabPairings,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.eco_outlined),
            activeIcon: const Icon(Icons.eco),
            label: l10n.tabGrapes,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite_border),
            activeIcon: const Icon(Icons.favorite),
            label: l10n.tabCellar,
          ),
        ],
      ),
    );
  }
}
