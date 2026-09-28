import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ro'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'Moldova Wine Explorer'**
  String get appTitle;

  /// No description provided for @tabWines.
  ///
  /// In ru, this message translates to:
  /// **'Вина'**
  String get tabWines;

  /// No description provided for @tabMap.
  ///
  /// In ru, this message translates to:
  /// **'Карта'**
  String get tabMap;

  /// No description provided for @tabPairings.
  ///
  /// In ru, this message translates to:
  /// **'Гастро-пары'**
  String get tabPairings;

  /// No description provided for @searchHint.
  ///
  /// In ru, this message translates to:
  /// **'Поиск вина или винодельни...'**
  String get searchHint;

  /// No description provided for @priceLdl.
  ///
  /// In ru, this message translates to:
  /// **'{price} MDL'**
  String priceLdl(int price);

  /// No description provided for @pairingPlaceholder.
  ///
  /// In ru, this message translates to:
  /// **'Подбор еды и вина'**
  String get pairingPlaceholder;

  /// No description provided for @language.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get language;

  /// No description provided for @wineTypeRedDry.
  ///
  /// In ru, this message translates to:
  /// **'Красное сухое'**
  String get wineTypeRedDry;

  /// No description provided for @wineTypeWhiteDry.
  ///
  /// In ru, this message translates to:
  /// **'Белое сухое'**
  String get wineTypeWhiteDry;

  /// No description provided for @wineTypeRoseDry.
  ///
  /// In ru, this message translates to:
  /// **'Розовое сухое'**
  String get wineTypeRoseDry;

  /// No description provided for @wineTypeSparkling.
  ///
  /// In ru, this message translates to:
  /// **'Игристое'**
  String get wineTypeSparkling;

  /// No description provided for @vintageYear.
  ///
  /// In ru, this message translates to:
  /// **'{year} год'**
  String vintageYear(int year);

  /// No description provided for @detailTasting.
  ///
  /// In ru, this message translates to:
  /// **'Описание и вкус'**
  String get detailTasting;

  /// No description provided for @detailPairing.
  ///
  /// In ru, this message translates to:
  /// **'С чем сочетается'**
  String get detailPairing;

  /// No description provided for @noDescription.
  ///
  /// In ru, this message translates to:
  /// **'Описание пока отсутствует.'**
  String get noDescription;

  /// No description provided for @pairingRed.
  ///
  /// In ru, this message translates to:
  /// **'Идеально подходит к плациндам с мясом, точкэре, шашлыку на гратаре и выдержанным овечьим сырам (брынзе).'**
  String get pairingRed;

  /// No description provided for @pairingWhite.
  ///
  /// In ru, this message translates to:
  /// **'Прекрасно сочетается с замой из домашней курицы, мамалыгой с рыбой и свежими сырами.'**
  String get pairingWhite;

  /// No description provided for @pairingRose.
  ///
  /// In ru, this message translates to:
  /// **'Отлично подходит к летним салатам, запечённым овощам и молодой брынзе.'**
  String get pairingRose;

  /// No description provided for @pairingSparkling.
  ///
  /// In ru, this message translates to:
  /// **'Хорош как аперитив, с морепродуктами и десертами.'**
  String get pairingSparkling;

  /// No description provided for @favoriteAdd.
  ///
  /// In ru, this message translates to:
  /// **'Добавить в мой подвал'**
  String get favoriteAdd;

  /// No description provided for @favoriteRemove.
  ///
  /// In ru, this message translates to:
  /// **'Убрать из подвала'**
  String get favoriteRemove;

  /// No description provided for @favoriteAdded.
  ///
  /// In ru, this message translates to:
  /// **'Добавлено в ваш подвал'**
  String get favoriteAdded;

  /// No description provided for @favoriteRemoved.
  ///
  /// In ru, this message translates to:
  /// **'Удалено из подвала'**
  String get favoriteRemoved;

  /// No description provided for @noResults.
  ///
  /// In ru, this message translates to:
  /// **'Ничего не найдено'**
  String get noResults;

  /// No description provided for @mapWinesCount.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, =0{Вин пока нет в каталоге} one{{count} вино в каталоге} few{{count} вина в каталоге} many{{count} вин в каталоге} other{{count} вина в каталоге}}'**
  String mapWinesCount(int count);

  /// No description provided for @mapRoute.
  ///
  /// In ru, this message translates to:
  /// **'Маршрут'**
  String get mapRoute;

  /// No description provided for @mapRouteError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось открыть карты'**
  String get mapRouteError;

  /// No description provided for @mapShowAll.
  ///
  /// In ru, this message translates to:
  /// **'Показать все винодельни'**
  String get mapShowAll;

  /// No description provided for @tabCellar.
  ///
  /// In ru, this message translates to:
  /// **'Подвал'**
  String get tabCellar;

  /// No description provided for @cellarEmptyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Ваш подвал пока пуст'**
  String get cellarEmptyTitle;

  /// No description provided for @cellarEmptyHint.
  ///
  /// In ru, this message translates to:
  /// **'Нажмите ♡ на странице вина, чтобы сохранить его здесь.'**
  String get cellarEmptyHint;

  /// No description provided for @cellarBrowse.
  ///
  /// In ru, this message translates to:
  /// **'Перейти в каталог'**
  String get cellarBrowse;

  /// No description provided for @pairingQuestion.
  ///
  /// In ru, this message translates to:
  /// **'Что у вас на столе?'**
  String get pairingQuestion;

  /// No description provided for @pairingMatches.
  ///
  /// In ru, this message translates to:
  /// **'Подходящие вина'**
  String get pairingMatches;

  /// No description provided for @pairingNoMatches.
  ///
  /// In ru, this message translates to:
  /// **'В каталоге пока нет подходящих вин'**
  String get pairingNoMatches;

  /// No description provided for @dishPlacinte.
  ///
  /// In ru, this message translates to:
  /// **'Плацинды'**
  String get dishPlacinte;

  /// No description provided for @dishTochitura.
  ///
  /// In ru, this message translates to:
  /// **'Токана / точкэре'**
  String get dishTochitura;

  /// No description provided for @dishZeama.
  ///
  /// In ru, this message translates to:
  /// **'Зама'**
  String get dishZeama;

  /// No description provided for @dishMamaliga.
  ///
  /// In ru, this message translates to:
  /// **'Мамалыга с брынзой'**
  String get dishMamaliga;

  /// No description provided for @dishGrill.
  ///
  /// In ru, this message translates to:
  /// **'Шашлык на гратаре'**
  String get dishGrill;

  /// No description provided for @dishFish.
  ///
  /// In ru, this message translates to:
  /// **'Рыба'**
  String get dishFish;

  /// No description provided for @dishCheese.
  ///
  /// In ru, this message translates to:
  /// **'Сыры'**
  String get dishCheese;

  /// No description provided for @dishDessert.
  ///
  /// In ru, this message translates to:
  /// **'Десерты'**
  String get dishDessert;

  /// No description provided for @dishReasonPlacinte.
  ///
  /// In ru, this message translates to:
  /// **'Сытная выпечка с мясом или брынзой любит мягкое красное или свежее розовое — вино не перебьёт начинку.'**
  String get dishReasonPlacinte;

  /// No description provided for @dishReasonTochitura.
  ///
  /// In ru, this message translates to:
  /// **'Насыщенное мясное рагу требует танинного красного: Фетяска Нягрэ или Рарэ Нягрэ раскрываются рядом с ним лучше всего.'**
  String get dishReasonTochitura;

  /// No description provided for @dishReasonZeama.
  ///
  /// In ru, this message translates to:
  /// **'Кисловатый куриный суп с борщом и зеленью хорошо освежает сухое белое с яркой кислотностью.'**
  String get dishReasonZeama;

  /// No description provided for @dishReasonMamaliga.
  ///
  /// In ru, this message translates to:
  /// **'Сливочная мамалыга со сметаной и брынзой просит лёгкое белое или розовое, которое освежит вкус.'**
  String get dishReasonMamaliga;

  /// No description provided for @dishReasonGrill.
  ///
  /// In ru, this message translates to:
  /// **'Дымное мясо с углей — классика для сухого красного с плотным телом.'**
  String get dishReasonGrill;

  /// No description provided for @dishReasonFish.
  ///
  /// In ru, this message translates to:
  /// **'Речная рыба и морепродукты идеальны с хрустящим белым или игристым.'**
  String get dishReasonFish;

  /// No description provided for @dishReasonCheese.
  ///
  /// In ru, this message translates to:
  /// **'Солёной выдержанной брынзе подойдёт красное, свежим сырам — белое.'**
  String get dishReasonCheese;

  /// No description provided for @dishReasonDessert.
  ///
  /// In ru, this message translates to:
  /// **'Вертута, куличи и фрукты хорошо сочетаются с игристым вином.'**
  String get dishReasonDessert;

  /// No description provided for @loadError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить каталог. Проверьте интернет.'**
  String get loadError;

  /// No description provided for @retry.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get retry;

  /// No description provided for @filters.
  ///
  /// In ru, this message translates to:
  /// **'Фильтры'**
  String get filters;

  /// No description provided for @filterPrice.
  ///
  /// In ru, this message translates to:
  /// **'Цена'**
  String get filterPrice;

  /// No description provided for @filterWineries.
  ///
  /// In ru, this message translates to:
  /// **'Винодельни'**
  String get filterWineries;

  /// No description provided for @filterReset.
  ///
  /// In ru, this message translates to:
  /// **'Сбросить'**
  String get filterReset;

  /// No description provided for @filterShow.
  ///
  /// In ru, this message translates to:
  /// **'Показать ({count})'**
  String filterShow(int count);

  /// No description provided for @filterResults.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, =0{Ничего не найдено} one{Найдено {count} вино} few{Найдено {count} вина} many{Найдено {count} вин} other{Найдено {count} вина}}'**
  String filterResults(int count);

  /// No description provided for @sortBy.
  ///
  /// In ru, this message translates to:
  /// **'Сортировка'**
  String get sortBy;

  /// No description provided for @sortRating.
  ///
  /// In ru, this message translates to:
  /// **'По рейтингу'**
  String get sortRating;

  /// No description provided for @sortPriceAsc.
  ///
  /// In ru, this message translates to:
  /// **'Сначала дешёвые'**
  String get sortPriceAsc;

  /// No description provided for @sortPriceDesc.
  ///
  /// In ru, this message translates to:
  /// **'Сначала дорогие'**
  String get sortPriceDesc;

  /// No description provided for @sortVintage.
  ///
  /// In ru, this message translates to:
  /// **'Сначала новые урожаи'**
  String get sortVintage;

  /// No description provided for @sortName.
  ///
  /// In ru, this message translates to:
  /// **'По названию'**
  String get sortName;

  /// No description provided for @clearSearch.
  ///
  /// In ru, this message translates to:
  /// **'Очистить поиск'**
  String get clearSearch;

  /// No description provided for @offlineBanner.
  ///
  /// In ru, this message translates to:
  /// **'Нет подключения · данные от {date}'**
  String offlineBanner(String date);

  /// No description provided for @offlineBannerNoDate.
  ///
  /// In ru, this message translates to:
  /// **'Нет подключения · показаны сохранённые данные'**
  String get offlineBannerNoDate;

  /// No description provided for @ageTitle.
  ///
  /// In ru, this message translates to:
  /// **'Вам есть 18 лет?'**
  String get ageTitle;

  /// No description provided for @ageText.
  ///
  /// In ru, this message translates to:
  /// **'В приложении есть информация об алкогольной продукции. Оно предназначено только для совершеннолетних.'**
  String get ageText;

  /// No description provided for @ageYes.
  ///
  /// In ru, this message translates to:
  /// **'Да, мне есть 18'**
  String get ageYes;

  /// No description provided for @ageNo.
  ///
  /// In ru, this message translates to:
  /// **'Нет'**
  String get ageNo;

  /// No description provided for @ageDeniedTitle.
  ///
  /// In ru, this message translates to:
  /// **'Приложение доступно с 18 лет'**
  String get ageDeniedTitle;

  /// No description provided for @ageDeniedText.
  ///
  /// In ru, this message translates to:
  /// **'Возвращайтесь, когда вам исполнится 18.'**
  String get ageDeniedText;

  /// No description provided for @ageBack.
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get ageBack;

  /// No description provided for @ageHealthWarning.
  ///
  /// In ru, this message translates to:
  /// **'Чрезмерное употребление алкоголя вредит вашему здоровью.'**
  String get ageHealthWarning;

  /// No description provided for @wineryMore.
  ///
  /// In ru, this message translates to:
  /// **'Подробнее'**
  String get wineryMore;

  /// No description provided for @wineryAbout.
  ///
  /// In ru, this message translates to:
  /// **'О винодельне'**
  String get wineryAbout;

  /// No description provided for @wineryFounded.
  ///
  /// In ru, this message translates to:
  /// **'Основана в {year} году'**
  String wineryFounded(int year);

  /// No description provided for @wineryNoInfo.
  ///
  /// In ru, this message translates to:
  /// **'Подробная информация пока не добавлена.'**
  String get wineryNoInfo;

  /// No description provided for @wineryTastings.
  ///
  /// In ru, this message translates to:
  /// **'Дегустации'**
  String get wineryTastings;

  /// No description provided for @wineryTastingsYes.
  ///
  /// In ru, this message translates to:
  /// **'Проводятся'**
  String get wineryTastingsYes;

  /// No description provided for @wineryTastingsNo.
  ///
  /// In ru, this message translates to:
  /// **'Не проводятся'**
  String get wineryTastingsNo;

  /// No description provided for @wineryTastingFrom.
  ///
  /// In ru, this message translates to:
  /// **'от {price} MDL'**
  String wineryTastingFrom(int price);

  /// No description provided for @wineryBookingRequired.
  ///
  /// In ru, this message translates to:
  /// **'Нужна предварительная запись'**
  String get wineryBookingRequired;

  /// No description provided for @wineryHours.
  ///
  /// In ru, this message translates to:
  /// **'Часы работы'**
  String get wineryHours;

  /// No description provided for @wineryAddress.
  ///
  /// In ru, this message translates to:
  /// **'Адрес'**
  String get wineryAddress;

  /// No description provided for @wineryPhone.
  ///
  /// In ru, this message translates to:
  /// **'Телефон'**
  String get wineryPhone;

  /// No description provided for @wineryWebsite.
  ///
  /// In ru, this message translates to:
  /// **'Сайт'**
  String get wineryWebsite;

  /// No description provided for @wineryWines.
  ///
  /// In ru, this message translates to:
  /// **'Вина винодельни'**
  String get wineryWines;

  /// No description provided for @openError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось открыть'**
  String get openError;

  /// No description provided for @tabGrapes.
  ///
  /// In ru, this message translates to:
  /// **'Сорта'**
  String get tabGrapes;

  /// No description provided for @grapesNative.
  ///
  /// In ru, this message translates to:
  /// **'Местные сорта'**
  String get grapesNative;

  /// No description provided for @grapesInternational.
  ///
  /// In ru, this message translates to:
  /// **'Международные сорта'**
  String get grapesInternational;

  /// No description provided for @grapesEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Справочник пока пуст.'**
  String get grapesEmpty;

  /// No description provided for @grapeRed.
  ///
  /// In ru, this message translates to:
  /// **'Красный'**
  String get grapeRed;

  /// No description provided for @grapeWhite.
  ///
  /// In ru, this message translates to:
  /// **'Белый'**
  String get grapeWhite;

  /// No description provided for @grapeNativeBadge.
  ///
  /// In ru, this message translates to:
  /// **'Местный сорт'**
  String get grapeNativeBadge;

  /// No description provided for @grapeAliases.
  ///
  /// In ru, this message translates to:
  /// **'Другие названия: {names}'**
  String grapeAliases(String names);

  /// No description provided for @grapeAbout.
  ///
  /// In ru, this message translates to:
  /// **'О сорте'**
  String get grapeAbout;

  /// No description provided for @grapeTaste.
  ///
  /// In ru, this message translates to:
  /// **'Вкус и аромат'**
  String get grapeTaste;

  /// No description provided for @grapeWines.
  ///
  /// In ru, this message translates to:
  /// **'Вина из этого сорта'**
  String get grapeWines;

  /// No description provided for @grapeNoWines.
  ///
  /// In ru, this message translates to:
  /// **'В каталоге пока нет вин из этого сорта.'**
  String get grapeNoWines;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ro', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
