import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wine_explorer/core/favorites_controller.dart';
import 'package:wine_explorer/core/locale_controller.dart';
import 'package:wine_explorer/data/catalog_store.dart';
import 'package:wine_explorer/main.dart';
import 'package:wine_explorer/screens/wine_detail_screen.dart';

void main() {
  testWidgets('карточка открывает детальный экран и добавляет в подвал', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await setAppLocale('ru');
    await loadFavorites();
    await catalog.load();

    await tester.pumpWidget(const WineExplorerApp());
    await tester.tap(find.text('Viorica de Purcari'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(WineDetailScreen), findsOneWidget);
    expect(find.text('Белое сухое'), findsOneWidget);

    await tester.tap(find.text('Добавить в мой подвал'));
    await tester.pump();
    expect(isFavorite('2'), isTrue);
    expect(find.text('Убрать из подвала'), findsOneWidget);
  });
}
