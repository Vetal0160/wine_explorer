import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Открывает ссылку во внешнем приложении (карты, звонилка, браузер).
/// Если не получилось — показывает [errorText].
Future<void> openExternal(
  BuildContext context,
  Uri uri, {
  required String errorText,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  bool ok;
  try {
    ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    ok = false;
  }
  if (!ok) messenger.showSnackBar(SnackBar(content: Text(errorText)));
}

/// Политика конфиденциальности (GitHub Pages, папка docs/).
const privacyPolicyUrl =
    'https://vetal0160.github.io/wine_explorer/privacy-policy.html';

/// Маршрут до точки в Google Картах (или в браузере).
Uri routeUri(double latitude, double longitude) => Uri.parse(
  'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude',
);

/// Звонок: убираем пробелы и скобки, оставляем + и цифры.
Uri phoneUri(String phone) =>
    Uri(scheme: 'tel', path: phone.replaceAll(RegExp(r'[^\d+]'), ''));

/// Сайт: если схема не указана — добавляем https://.
Uri websiteUri(String website) => Uri.parse(
  website.startsWith(RegExp(r'https?://')) ? website : 'https://$website',
);

/// «purcari.wine» вместо «https://www.purcari.wine/» — для показа.
String prettyWebsite(String website) => website
    .replaceFirst(RegExp(r'^https?://'), '')
    .replaceFirst(RegExp(r'^www\.'), '')
    .replaceFirst(RegExp(r'/$'), '');
