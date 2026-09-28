import 'app_localizations.dart';

/// Переводит код типа вина (например, 'red_dry') в подпись на текущем языке.
/// Неизвестные значения возвращаются как есть.
String localizedWineType(AppLocalizations l10n, String type) {
  switch (type) {
    case 'red_dry':
      return l10n.wineTypeRedDry;
    case 'white_dry':
      return l10n.wineTypeWhiteDry;
    case 'rose_dry':
      return l10n.wineTypeRoseDry;
    case 'sparkling':
      return l10n.wineTypeSparkling;
    default:
      return type;
  }
}

/// Гастро-пара по типу вина. Для неизвестных типов — вариант для белого.
String localizedPairing(AppLocalizations l10n, String type) {
  if (type.startsWith('red')) return l10n.pairingRed;
  if (type.startsWith('rose')) return l10n.pairingRose;
  if (type == 'sparkling') return l10n.pairingSparkling;
  return l10n.pairingWhite;
}
