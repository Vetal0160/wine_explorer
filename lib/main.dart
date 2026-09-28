import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'l10n/app_localizations.dart';
import 'core/age_gate_controller.dart';
import 'core/favorites_controller.dart';
import 'core/supabase_config.dart';
import 'data/catalog_store.dart';
import 'data/supabase_wine_repository.dart';
import 'core/locale_controller.dart';
import 'core/theme.dart';
import 'screens/age_gate_screen.dart';
import 'screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Future.wait([loadSavedLocale(), loadFavorites(), loadAgeConfirmed()]);
  } catch (e) {
    // Настройки не загрузились — стартуем с языком системы и пустым подвалом
    debugPrint('Не удалось загрузить сохранённые настройки: $e');
  }

  // Есть ключи Supabase — берём каталог оттуда, иначе тестовые данные
  if (isSupabaseConfigured) {
    try {
      await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseKey);
      catalog.repository = SupabaseWineRepository();
    } catch (e) {
      debugPrint('Supabase не инициализирован, используем тестовые данные: $e');
    }
  }
  // Сохранённый каталог показываем сразу, свежий догружаем в фоне
  await catalog.restoreFromCache();
  catalog.load();
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
            Locale(
              'ru',
            ), // Русский (используется, если язык телефона не поддерживается)
            Locale('ro'), // Румынский
            Locale('en'), // Английский
          ],
          // null — берётся язык телефона; иначе язык, выбранный в меню
          locale: locale,

          // Пока возраст не подтверждён — экран «Вам есть 18 лет?»
          home: ValueListenableBuilder<bool>(
            valueListenable: ageConfirmed,
            builder: (context, confirmed, _) =>
                confirmed ? const MainScreen() : const AgeGateScreen(),
          ),
        );
      },
    );
  }
}
