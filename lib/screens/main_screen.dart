import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../core/locale_controller.dart';
import '../data/catalog_store.dart';
import 'catalog_screen.dart';
import 'cellar_screen.dart';
import 'map_screen.dart';
import 'pairing_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            tooltip: l10n.language,
            onSelected: setAppLocale,
            itemBuilder: (context) => [
              for (final entry in supportedLanguages.entries)
                CheckedPopupMenuItem(
                  value: entry.key,
                  checked:
                      Localizations.localeOf(context).languageCode == entry.key,
                  child: Text(entry.value),
                ),
            ],
          ),
        ],
      ),
      body: switch (_currentIndex) {
        0 => const CatalogScreen(),
        1 => const MapScreen(),
        2 => const PairingScreen(),
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
            icon: const Icon(Icons.favorite_border),
            activeIcon: const Icon(Icons.favorite),
            label: l10n.tabCellar,
          ),
        ],
      ),
    );
  }
}
