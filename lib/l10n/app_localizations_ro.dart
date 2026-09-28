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

  @override
  String get tabCellar => 'Crama';

  @override
  String get cellarEmptyTitle => 'Crama ta este goală deocamdată';

  @override
  String get cellarEmptyHint =>
      'Apasă ♡ pe pagina unui vin pentru a-l salva aici.';

  @override
  String get cellarBrowse => 'Mergi la catalog';

  @override
  String get pairingQuestion => 'Ce ai pe masă?';

  @override
  String get pairingMatches => 'Vinuri potrivite';

  @override
  String get pairingNoMatches =>
      'Deocamdată nu sunt vinuri potrivite în catalog';

  @override
  String get dishPlacinte => 'Plăcinte';

  @override
  String get dishTochitura => 'Tocană / tochitură';

  @override
  String get dishZeama => 'Zeamă';

  @override
  String get dishMamaliga => 'Mămăligă cu brânză';

  @override
  String get dishGrill => 'Frigărui la grătar';

  @override
  String get dishFish => 'Pește';

  @override
  String get dishCheese => 'Brânzeturi';

  @override
  String get dishDessert => 'Deserturi';

  @override
  String get dishReasonPlacinte =>
      'Plăcintele cu carne sau brânză se potrivesc cu un roșu moale sau un rose proaspăt — vinul nu acoperă umplutura.';

  @override
  String get dishReasonTochitura =>
      'Tocănița bogată cere un roșu tanic: Fetească Neagră sau Rară Neagră se deschid cel mai bine alături de ea.';

  @override
  String get dishReasonZeama =>
      'Zeama acrișoară cu borș și verdeață e împrospătată de un alb sec cu aciditate vie.';

  @override
  String get dishReasonMamaliga =>
      'Mămăliga cremoasă cu smântână și brânză cere un alb sau rose ușor, care împrospătează gustul.';

  @override
  String get dishReasonGrill =>
      'Carnea afumată de pe jar este clasica pentru un roșu sec corpolent.';

  @override
  String get dishReasonFish =>
      'Peștele de râu și fructele de mare sunt ideale cu un alb crocant sau un spumant.';

  @override
  String get dishReasonCheese =>
      'Brânza de oi maturată și sărată merge cu roșu, iar brânzeturile proaspete — cu alb.';

  @override
  String get dishReasonDessert =>
      'Vertuta, cozonacul și fructele se potrivesc bine cu un vin spumant.';

  @override
  String get loadError =>
      'Catalogul nu s-a putut încărca. Verificați conexiunea la internet.';

  @override
  String get retry => 'Reîncearcă';

  @override
  String get filters => 'Filtre';

  @override
  String get filterPrice => 'Preț';

  @override
  String get filterWineries => 'Vinării';

  @override
  String get filterReset => 'Resetează';

  @override
  String filterShow(int count) {
    return 'Arată ($count)';
  }

  @override
  String filterResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de vinuri găsite',
      few: '$count vinuri găsite',
      one: 'Un vin găsit',
      zero: 'Niciun vin găsit',
    );
    return '$_temp0';
  }

  @override
  String get sortBy => 'Sortare';

  @override
  String get sortRating => 'După rating';

  @override
  String get sortPriceAsc => 'Cele mai ieftine';

  @override
  String get sortPriceDesc => 'Cele mai scumpe';

  @override
  String get sortVintage => 'Recolte noi întâi';

  @override
  String get sortName => 'După nume';

  @override
  String get clearSearch => 'Șterge căutarea';

  @override
  String offlineBanner(String date) {
    return 'Fără conexiune · date din $date';
  }

  @override
  String get offlineBannerNoDate =>
      'Fără conexiune · se afișează datele salvate';

  @override
  String get ageTitle => 'Ai împlinit 18 ani?';

  @override
  String get ageText =>
      'Aplicația conține informații despre băuturi alcoolice și este destinată doar persoanelor majore.';

  @override
  String get ageYes => 'Da, am peste 18 ani';

  @override
  String get ageNo => 'Nu';

  @override
  String get ageDeniedTitle => 'Aplicația este disponibilă de la 18 ani';

  @override
  String get ageDeniedText => 'Revino când vei împlini 18 ani.';

  @override
  String get ageBack => 'Înapoi';

  @override
  String get ageHealthWarning =>
      'Consumul excesiv de alcool dăunează sănătății.';

  @override
  String get wineryMore => 'Detalii';

  @override
  String get wineryAbout => 'Despre vinărie';

  @override
  String wineryFounded(int year) {
    return 'Fondată în $year';
  }

  @override
  String get wineryNoInfo => 'Informațiile detaliate nu au fost încă adăugate.';

  @override
  String get wineryTastings => 'Degustări';

  @override
  String get wineryTastingsYes => 'Disponibile';

  @override
  String get wineryTastingsNo => 'Nu sunt disponibile';

  @override
  String wineryTastingFrom(int price) {
    return 'de la $price MDL';
  }

  @override
  String get wineryBookingRequired => 'Este necesară rezervarea';

  @override
  String get wineryHours => 'Program';

  @override
  String get wineryAddress => 'Adresa';

  @override
  String get wineryPhone => 'Telefon';

  @override
  String get wineryWebsite => 'Site web';

  @override
  String get wineryWines => 'Vinurile vinăriei';

  @override
  String get openError => 'Nu s-a putut deschide';

  @override
  String get tabGrapes => 'Soiuri';

  @override
  String get grapesNative => 'Soiuri autohtone';

  @override
  String get grapesInternational => 'Soiuri internaționale';

  @override
  String get grapesEmpty => 'Ghidul este deocamdată gol.';

  @override
  String get grapeRed => 'Roșu';

  @override
  String get grapeWhite => 'Alb';

  @override
  String get grapeNativeBadge => 'Soi autohton';

  @override
  String grapeAliases(String names) {
    return 'Alte denumiri: $names';
  }

  @override
  String get grapeAbout => 'Despre soi';

  @override
  String get grapeTaste => 'Gust și aromă';

  @override
  String get grapeWines => 'Vinuri din acest soi';

  @override
  String get grapeNoWines =>
      'Deocamdată nu sunt vinuri din acest soi în catalog.';

  @override
  String get share => 'Distribuie';

  @override
  String get shareFooter => 'Găsit în aplicația Moldova Wine Explorer';

  @override
  String get myNotes => 'Notițele mele';

  @override
  String get addNote => 'Adaugă o notiță';

  @override
  String get editNote => 'Editează';

  @override
  String get noteRating => 'Nota mea';

  @override
  String get noteText => 'Impresii';

  @override
  String get noteTextHint => 'Gust, cu ce l-ai băut, ți-a plăcut…';

  @override
  String get notePlace => 'Unde l-ai cumpărat sau gustat';

  @override
  String get notePlaceHint => 'Magazin, vinărie, restaurant';

  @override
  String get noteSave => 'Salvează';

  @override
  String get noteDelete => 'Șterge';

  @override
  String get noteSaved => 'Notița a fost salvată, vinul e în crama ta';
}
