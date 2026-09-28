// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Moldova Wine Explorer';

  @override
  String get tabWines => 'Wines';

  @override
  String get tabMap => 'Map';

  @override
  String get tabPairings => 'Pairings';

  @override
  String get searchHint => 'Search wine or winery...';

  @override
  String priceLdl(int price) {
    return '$price MDL';
  }

  @override
  String get pairingPlaceholder => 'Food & wine pairing';

  @override
  String get language => 'Language';

  @override
  String get wineTypeRedDry => 'Red dry';

  @override
  String get wineTypeWhiteDry => 'White dry';

  @override
  String get wineTypeRoseDry => 'Rosé dry';

  @override
  String get wineTypeSparkling => 'Sparkling';

  @override
  String vintageYear(int year) {
    return 'Vintage $year';
  }

  @override
  String get detailTasting => 'Description & taste';

  @override
  String get detailPairing => 'Pairs well with';

  @override
  String get noDescription => 'No description yet.';

  @override
  String get pairingRed =>
      'Perfect with meat plăcinte, tochitură, grilled skewers and aged sheep\'s cheese (brânză).';

  @override
  String get pairingWhite =>
      'Goes beautifully with homemade chicken zeamă, mămăligă with fish and fresh cheeses.';

  @override
  String get pairingRose =>
      'Great with summer salads, roasted vegetables and young brânză.';

  @override
  String get pairingSparkling =>
      'Lovely as an aperitif, with seafood and desserts.';

  @override
  String get favoriteAdd => 'Add to my cellar';

  @override
  String get favoriteRemove => 'Remove from cellar';

  @override
  String get favoriteAdded => 'Added to your cellar';

  @override
  String get favoriteRemoved => 'Removed from your cellar';

  @override
  String get noResults => 'Nothing found';

  @override
  String mapWinesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wines in the catalog',
      one: '1 wine in the catalog',
      zero: 'No wines in the catalog yet',
    );
    return '$_temp0';
  }

  @override
  String get mapRoute => 'Directions';

  @override
  String get mapRouteError => 'Couldn\'t open maps';

  @override
  String get mapShowAll => 'Show all wineries';
}
