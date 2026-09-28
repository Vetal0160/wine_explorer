import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'core/favorites_controller.dart';
import 'core/locale_controller.dart';
import 'core/theme.dart';
import 'screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Future.wait([loadSavedLocale(), loadFavorites()]);
  } catch (e) {
    // Настройки не загрузились — стартуем с языком системы и пустым подвалом
    debugPrint('Не удалось загрузить сохранённые настройки: $e');
  }
  runApp(const WineExplorerApp());
}

class WineExplorerApp extends StatelessWidget {
  const WineExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale?>(
      valueListenable: appLocale,
      builder: (context, locale, _) {
        return MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,

          // Настройка локализации:
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ru'), // Русский (используется, если язык телефона не поддерживается)
            Locale('ro'), // Румынский
            Locale('en'), // Английский
          ],
          // null — берётся язык телефона; иначе язык, выбранный в меню
          locale: locale,

          home: const MainScreen(),
        );
      },
    );
  }
}
