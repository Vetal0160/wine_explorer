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

  @override
  String get tabCellar => 'Cellar';

  @override
  String get cellarEmptyTitle => 'Your cellar is empty';

  @override
  String get cellarEmptyHint => 'Tap ♡ on a wine\'s page to save it here.';

  @override
  String get cellarBrowse => 'Browse the catalog';

  @override
  String get pairingQuestion => 'What\'s on your table?';

  @override
  String get pairingMatches => 'Matching wines';

  @override
  String get pairingNoMatches => 'No matching wines in the catalog yet';

  @override
  String get dishPlacinte => 'Plăcinte';

  @override
  String get dishTochitura => 'Tocană / tochitură';

  @override
  String get dishZeama => 'Zeamă';

  @override
  String get dishMamaliga => 'Mămăligă with brânză';

  @override
  String get dishGrill => 'Grilled skewers';

  @override
  String get dishFish => 'Fish';

  @override
  String get dishCheese => 'Cheese';

  @override
  String get dishDessert => 'Desserts';

  @override
  String get dishReasonPlacinte =>
      'Hearty pies with meat or cheese love a soft red or a fresh rosé that won\'t overpower the filling.';

  @override
  String get dishReasonTochitura =>
      'A rich meat stew calls for a tannic red: Fetească Neagră or Rară Neagră shine next to it.';

  @override
  String get dishReasonZeama =>
      'This tangy chicken soup with borș and herbs is lifted by a dry white with bright acidity.';

  @override
  String get dishReasonMamaliga =>
      'Creamy mămăligă with sour cream and brânză wants a light white or rosé to refresh the palate.';

  @override
  String get dishReasonGrill =>
      'Smoky meat from the coals is a classic match for a full-bodied dry red.';

  @override
  String get dishReasonFish =>
      'River fish and seafood are ideal with a crisp white or a sparkling wine.';

  @override
  String get dishReasonCheese =>
      'Salty aged sheep\'s cheese pairs with red; fresh cheeses go with white.';

  @override
  String get dishReasonDessert =>
      'Vertută, cozonac and fruit pair nicely with a sparkling wine.';

  @override
  String get loadError =>
      'Couldn\'t load the catalog. Check your internet connection.';

  @override
  String get retry => 'Retry';

  @override
  String get filters => 'Filters';

  @override
  String get filterPrice => 'Price';

  @override
  String get filterWineries => 'Wineries';

  @override
  String get filterReset => 'Reset';

  @override
  String filterShow(int count) {
    return 'Show ($count)';
  }

  @override
  String filterResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wines found',
      one: '1 wine found',
      zero: 'No wines found',
    );
    return '$_temp0';
  }

  @override
  String get sortBy => 'Sort';

  @override
  String get sortRating => 'Top rated';

  @override
  String get sortPriceAsc => 'Price: low to high';

  @override
  String get sortPriceDesc => 'Price: high to low';

  @override
  String get sortVintage => 'Newest vintage';

  @override
  String get sortName => 'Name A–Z';

  @override
  String get clearSearch => 'Clear search';

  @override
  String offlineBanner(String date) {
    return 'Offline · data from $date';
  }

  @override
  String get offlineBannerNoDate => 'Offline · showing saved data';
}
