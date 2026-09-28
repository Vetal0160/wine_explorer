import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';

import '../l10n/app_localizations.dart';
import '../l10n/wine_type_labels.dart';
import '../models/wine.dart';
import '../models/winery.dart';

/// Текст для отправки вина другу.
String wineShareText(AppLocalizations l10n, Wine wine, String languageCode) {
  final description = wine.descriptionFor(languageCode);
  return [
    '🍷 ${wine.name}',
    [wine.wineryName, if (wine.hasVintage) '${wine.vintage}'].join(' · '),
    [
      localizedWineType(l10n, wine.type),
      if (wine.hasRating) '★ ${wine.rating.toStringAsFixed(1)}',
      if (wine.hasPrice) '~${l10n.priceLdl(wine.priceLei.round())}',
    ].join(' · '),
    if (description.isNotEmpty) '\n$description',
    '\n${l10n.shareFooter}',
  ].join('\n');
}

/// Текст для отправки винодельни другу.
String wineryShareText(
  AppLocalizations l10n,
  Winery winery,
  String languageCode,
) {
  final description = winery.descriptionFor(languageCode);
  return [
    '🏰 ${winery.name}',
    if (winery.region != null) winery.region!,
    if (description.isNotEmpty) '\n$description',
    // Ссылка на карту — чтобы можно было сразу построить маршрут
    '\n📍 https://maps.google.com/?q=${winery.latitude},${winery.longitude}',
    if (winery.website != null) '🌐 ${winery.website}',
    '\n${l10n.shareFooter}',
  ].join('\n');
}

/// Системное окно «Поделиться» (Telegram, WhatsApp, почта…).
Future<void> shareText(BuildContext context, String text, {String? subject}) {
  // На планшетах окно привязывается к кнопке, иначе iPad бросает ошибку
  final box = context.findRenderObject() as RenderBox?;
  return SharePlus.instance.share(
    ShareParams(
      text: text,
      subject: subject,
      sharePositionOrigin: box == null
          ? null
          : box.localToGlobal(Offset.zero) & box.size,
    ),
  );
}
