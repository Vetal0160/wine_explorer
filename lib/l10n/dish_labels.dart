import '../data/dishes.dart';
import 'app_localizations.dart';

/// Название блюда на текущем языке.
String localizedDishName(AppLocalizations l10n, Dish dish) {
  switch (dish) {
    case Dish.placinte:
      return l10n.dishPlacinte;
    case Dish.tochitura:
      return l10n.dishTochitura;
    case Dish.zeama:
      return l10n.dishZeama;
    case Dish.mamaliga:
      return l10n.dishMamaliga;
    case Dish.grill:
      return l10n.dishGrill;
    case Dish.fish:
      return l10n.dishFish;
    case Dish.cheese:
      return l10n.dishCheese;
    case Dish.dessert:
      return l10n.dishDessert;
  }
}

/// Почему к блюду подходят именно такие вина.
String localizedDishReason(AppLocalizations l10n, Dish dish) {
  switch (dish) {
    case Dish.placinte:
      return l10n.dishReasonPlacinte;
    case Dish.tochitura:
      return l10n.dishReasonTochitura;
    case Dish.zeama:
      return l10n.dishReasonZeama;
    case Dish.mamaliga:
      return l10n.dishReasonMamaliga;
    case Dish.grill:
      return l10n.dishReasonGrill;
    case Dish.fish:
      return l10n.dishReasonFish;
    case Dish.cheese:
      return l10n.dishReasonCheese;
    case Dish.dessert:
      return l10n.dishReasonDessert;
  }
}
