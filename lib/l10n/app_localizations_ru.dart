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
}
