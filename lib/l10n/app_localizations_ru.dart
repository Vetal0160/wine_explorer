// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Moldova Wine Explorer';

  @override
  String get tabWines => 'Вина';

  @override
  String get tabMap => 'Карта';

  @override
  String get tabPairings => 'Гастро-пары';

  @override
  String get searchHint => 'Поиск вина или винодельни...';

  @override
  String priceLdl(int price) {
    return '$price MDL';
  }

  @override
  String get pairingPlaceholder => 'Подбор еды и вина';

  @override
  String get language => 'Язык';

  @override
  String get wineTypeRedDry => 'Красное сухое';

  @override
  String get wineTypeWhiteDry => 'Белое сухое';

  @override
  String get wineTypeRoseDry => 'Розовое сухое';

  @override
  String get wineTypeSparkling => 'Игристое';

  @override
  String vintageYear(int year) {
    return '$year год';
  }

  @override
  String get detailTasting => 'Описание и вкус';

  @override
  String get detailPairing => 'С чем сочетается';

  @override
  String get noDescription => 'Описание пока отсутствует.';

  @override
  String get pairingRed =>
      'Идеально подходит к плациндам с мясом, точкэре, шашлыку на гратаре и выдержанным овечьим сырам (брынзе).';

  @override
  String get pairingWhite =>
      'Прекрасно сочетается с замой из домашней курицы, мамалыгой с рыбой и свежими сырами.';

  @override
  String get pairingRose =>
      'Отлично подходит к летним салатам, запечённым овощам и молодой брынзе.';

  @override
  String get pairingSparkling =>
      'Хорош как аперитив, с морепродуктами и десертами.';

  @override
  String get favoriteAdd => 'Добавить в мой подвал';

  @override
  String get favoriteRemove => 'Убрать из подвала';

  @override
  String get favoriteAdded => 'Добавлено в ваш подвал';

  @override
  String get favoriteRemoved => 'Удалено из подвала';

  @override
  String get noResults => 'Ничего не найдено';

  @override
  String mapWinesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count вина в каталоге',
      many: '$count вин в каталоге',
      few: '$count вина в каталоге',
      one: '$count вино в каталоге',
      zero: 'Вин пока нет в каталоге',
    );
    return '$_temp0';
  }

  @override
  String get mapRoute => 'Маршрут';

  @override
  String get mapRouteError => 'Не удалось открыть карты';

  @override
  String get mapShowAll => 'Показать все винодельни';

  @override
  String get tabCellar => 'Подвал';

  @override
  String get cellarEmptyTitle => 'Ваш подвал пока пуст';

  @override
  String get cellarEmptyHint =>
      'Нажмите ♡ на странице вина, чтобы сохранить его здесь.';

  @override
  String get cellarBrowse => 'Перейти в каталог';

  @override
  String get pairingQuestion => 'Что у вас на столе?';

  @override
  String get pairingMatches => 'Подходящие вина';

  @override
  String get pairingNoMatches => 'В каталоге пока нет подходящих вин';

  @override
  String get dishPlacinte => 'Плацинды';

  @override
  String get dishTochitura => 'Токана / точкэре';

  @override
  String get dishZeama => 'Зама';

  @override
  String get dishMamaliga => 'Мамалыга с брынзой';

  @override
  String get dishGrill => 'Шашлык на гратаре';

  @override
  String get dishFish => 'Рыба';

  @override
  String get dishCheese => 'Сыры';

  @override
  String get dishDessert => 'Десерты';

  @override
  String get dishReasonPlacinte =>
      'Сытная выпечка с мясом или брынзой любит мягкое красное или свежее розовое — вино не перебьёт начинку.';

  @override
  String get dishReasonTochitura =>
      'Насыщенное мясное рагу требует танинного красного: Фетяска Нягрэ или Рарэ Нягрэ раскрываются рядом с ним лучше всего.';

  @override
  String get dishReasonZeama =>
      'Кисловатый куриный суп с борщом и зеленью хорошо освежает сухое белое с яркой кислотностью.';

  @override
  String get dishReasonMamaliga =>
      'Сливочная мамалыга со сметаной и брынзой просит лёгкое белое или розовое, которое освежит вкус.';

  @override
  String get dishReasonGrill =>
      'Дымное мясо с углей — классика для сухого красного с плотным телом.';

  @override
  String get dishReasonFish =>
      'Речная рыба и морепродукты идеальны с хрустящим белым или игристым.';

  @override
  String get dishReasonCheese =>
      'Солёной выдержанной брынзе подойдёт красное, свежим сырам — белое.';

  @override
  String get dishReasonDessert =>
      'Вертута, куличи и фрукты хорошо сочетаются с игристым вином.';

  @override
  String get loadError => 'Не удалось загрузить каталог. Проверьте интернет.';

  @override
  String get retry => 'Повторить';

  @override
  String get filters => 'Фильтры';

  @override
  String get filterPrice => 'Цена';

  @override
  String get filterWineries => 'Винодельни';

  @override
  String get filterReset => 'Сбросить';

  @override
  String filterShow(int count) {
    return 'Показать ($count)';
  }

  @override
  String filterResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Найдено $count вина',
      many: 'Найдено $count вин',
      few: 'Найдено $count вина',
      one: 'Найдено $count вино',
      zero: 'Ничего не найдено',
    );
    return '$_temp0';
  }

  @override
  String get sortBy => 'Сортировка';

  @override
  String get sortRating => 'По рейтингу';

  @override
  String get sortPriceAsc => 'Сначала дешёвые';

  @override
  String get sortPriceDesc => 'Сначала дорогие';

  @override
  String get sortVintage => 'Сначала новые урожаи';

  @override
  String get sortName => 'По названию';

  @override
  String get clearSearch => 'Очистить поиск';

  @override
  String offlineBanner(String date) {
    return 'Нет подключения · данные от $date';
  }

  @override
  String get offlineBannerNoDate =>
      'Нет подключения · показаны сохранённые данные';

  @override
  String get ageTitle => 'Вам есть 18 лет?';

  @override
  String get ageText =>
      'В приложении есть информация об алкогольной продукции. Оно предназначено только для совершеннолетних.';

  @override
  String get ageYes => 'Да, мне есть 18';

  @override
  String get ageNo => 'Нет';

  @override
  String get ageDeniedTitle => 'Приложение доступно с 18 лет';

  @override
  String get ageDeniedText => 'Возвращайтесь, когда вам исполнится 18.';

  @override
  String get ageBack => 'Назад';

  @override
  String get ageHealthWarning =>
      'Чрезмерное употребление алкоголя вредит вашему здоровью.';

  @override
  String get wineryMore => 'Подробнее';

  @override
  String get wineryAbout => 'О винодельне';

  @override
  String wineryFounded(int year) {
    return 'Основана в $year году';
  }

  @override
  String get wineryNoInfo => 'Подробная информация пока не добавлена.';

  @override
  String get wineryTastings => 'Дегустации';

  @override
  String get wineryTastingsYes => 'Проводятся';

  @override
  String get wineryTastingsNo => 'Не проводятся';

  @override
  String wineryTastingFrom(int price) {
    return 'от $price MDL';
  }

  @override
  String get wineryBookingRequired => 'Нужна предварительная запись';

  @override
  String get wineryHours => 'Часы работы';

  @override
  String get wineryAddress => 'Адрес';

  @override
  String get wineryPhone => 'Телефон';

  @override
  String get wineryWebsite => 'Сайт';

  @override
  String get wineryWines => 'Вина винодельни';

  @override
  String get openError => 'Не удалось открыть';

  @override
  String get tabGrapes => 'Сорта';

  @override
  String get grapesNative => 'Местные сорта';

  @override
  String get grapesInternational => 'Международные сорта';

  @override
  String get grapesEmpty => 'Справочник пока пуст.';

  @override
  String get grapeRed => 'Красный';

  @override
  String get grapeWhite => 'Белый';

  @override
  String get grapeNativeBadge => 'Местный сорт';

  @override
  String grapeAliases(String names) {
    return 'Другие названия: $names';
  }

  @override
  String get grapeAbout => 'О сорте';

  @override
  String get grapeTaste => 'Вкус и аромат';

  @override
  String get grapeWines => 'Вина из этого сорта';

  @override
  String get grapeNoWines => 'В каталоге пока нет вин из этого сорта.';

  @override
  String get share => 'Поделиться';

  @override
  String get shareFooter => 'Нашёл в приложении Moldova Wine Explorer';

  @override
  String get myNotes => 'Мои заметки';

  @override
  String get addNote => 'Добавить заметку';

  @override
  String get editNote => 'Изменить';

  @override
  String get noteRating => 'Моя оценка';

  @override
  String get noteText => 'Впечатления';

  @override
  String get noteTextHint => 'Вкус, с чем пили, понравилось ли…';

  @override
  String get notePlace => 'Где купил или пробовал';

  @override
  String get notePlaceHint => 'Магазин, винодельня, ресторан';

  @override
  String get noteSave => 'Сохранить';

  @override
  String get noteDelete => 'Удалить';

  @override
  String get noteSaved => 'Заметка сохранена, вино — в вашем подвале';

  @override
  String get about => 'О приложении';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get aboutText =>
      'Бесплатный гид по винам, винодельням и сортам винограда Молдовы. Приложение носит информационный характер и не продаёт алкоголь.';

  @override
  String get nearMe => 'Рядом с вами';

  @override
  String get mapWineriesTitle => 'Винодельни';

  @override
  String get myLocation => 'Где я';

  @override
  String distanceKm(String km) {
    return '$km км';
  }

  @override
  String get locationDenied =>
      'Без доступа к местоположению не получится показать винодельни рядом';

  @override
  String get locationDeniedForever =>
      'Доступ к местоположению запрещён в настройках приложения';

  @override
  String get locationServiceOff => 'Геолокация на телефоне выключена';

  @override
  String get locationFailed => 'Не удалось определить местоположение';

  @override
  String get openSettings => 'Настройки';
}
