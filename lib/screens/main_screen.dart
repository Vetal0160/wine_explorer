import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../core/locale_controller.dart';
import 'catalog_screen.dart';
import 'map_screen.dart';
import 'pairing_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    CatalogScreen(),
    MapScreen(),
    PairingScreen(),
  ];

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
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
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
        ],
      ),
    );
  }
}