// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appTitle => 'Moldova Wine Explorer';

  @override
  String get tabWines => 'Vinuri';

  @override
  String get tabMap => 'Hartă';

  @override
  String get tabPairings => 'Gastronomie';

  @override
  String get searchHint => 'Căutare vin sau vinărie...';

  @override
  String priceLdl(int price) {
    return '$price MDL';
  }

  @override
  String get pairingPlaceholder => 'Asocierea vinului cu mâncarea';

  @override
  String get language => 'Limba';

  @override
  String get wineTypeRedDry => 'Roșu sec';

  @override
  String get wineTypeWhiteDry => 'Alb sec';

  @override
  String get wineTypeRoseDry => 'Roze sec';

  @override
  String get wineTypeSparkling => 'Spumant';

  @override
  String vintageYear(int year) {
    return 'anul $year';
  }

  @override
  String get detailTasting => 'Descriere și gust';

  @override
  String get detailPairing => 'Se asociază cu';

  @override
  String get noDescription => 'Descrierea lipsește deocamdată.';

  @override
  String get pairingRed =>
      'Ideal pentru plăcinte cu carne, tochitură, frigărui la grătar și brânză de oi maturată.';

  @override
  String get pairingWhite =>
      'Se potrivește perfect cu zeamă de găină de casă, mămăligă cu pește și brânzeturi proaspete.';

  @override
  String get pairingRose =>
      'Excelent cu salate de vară, legume coapte și brânză tânără.';

  @override
  String get pairingSparkling =>
      'Potrivit ca aperitiv, cu fructe de mare și deserturi.';

  @override
  String get favoriteAdd => 'Adaugă în crama mea';

  @override
  String get favoriteRemove => 'Scoate din cramă';

  @override
  String get favoriteAdded => 'Adăugat în crama ta';

  @override
  String get favoriteRemoved => 'Scos din cramă';

  @override
  String get noResults => 'Niciun rezultat';

  @override
  String mapWinesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de vinuri în catalog',
      few: '$count vinuri în catalog',
      one: 'Un vin în catalog',
      zero: 'Niciun vin în catalog',
    );
    return '$_temp0';
  }

  @override
  String get mapRoute => 'Traseu';

  @override
  String get mapRouteError => 'Nu s-au putut deschide hărțile';

  @override
  String get mapShowAll => 'Arată toate vinăriile';
}
