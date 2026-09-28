import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _localeKey = 'app_locale';

/// Выбранный пользователем язык. null — язык системы.
final ValueNotifier<Locale?> appLocale = ValueNotifier<Locale?>(null);

/// Языки приложения с названиями на родном языке.
const Map<String, String> supportedLanguages = {
  'ru': 'Русский',
  'ro': 'Română',
  'en': 'English',
};

/// Загружает сохранённый язык (вызывается при старте приложения).
Future<void> loadSavedLocale() async {
  final prefs = await SharedPreferences.getInstance();
  final code = prefs.getString(_localeKey);
  if (code != null && supportedLanguages.containsKey(code)) {
    appLocale.value = Locale(code);
  }
}

/// Меняет язык и запоминает выбор.
Future<void> setAppLocale(String code) async {
  appLocale.value = Locale(code);
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_localeKey, code);
}
