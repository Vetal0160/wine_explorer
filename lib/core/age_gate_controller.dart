import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _ageConfirmedKey = 'age_confirmed';

/// Пользователь подтвердил, что ему есть 18 лет (спрашиваем один раз).
final ValueNotifier<bool> ageConfirmed = ValueNotifier<bool>(false);

/// Загружает ответ (вызывается при старте приложения).
Future<void> loadAgeConfirmed() async {
  final prefs = await SharedPreferences.getInstance();
  ageConfirmed.value = prefs.getBool(_ageConfirmedKey) ?? false;
}

Future<void> confirmAge() async {
  ageConfirmed.value = true;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_ageConfirmedKey, true);
}
