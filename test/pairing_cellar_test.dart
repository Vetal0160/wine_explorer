import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wine_explorer/core/favorites_controller.dart';
import 'package:wine_explorer/core/locale_controller.dart';
import 'package:wine_explorer/main.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await setAppLocale('ru');
    await loadFavorites();
  });

  testWidgets('подбор: десерты предлагают только игристое', (tester) async {
    await tester.pumpWidget(const WineExplorerApp());
    await tester.tap(find.text('Гастро-пары'));
    await settle(tester);

    await tester.tap(find.text('Десерты'));
    await settle(tester);

    expect(find.text('Cricova Brut'), findsOneWidget);
    expect(find.text('Viorica de Purcari'), findsNothing);
  });

  testWidgets('подвал: пустое состояние, затем добавленное вино',
      (tester) async {
    await tester.pumpWidget(const WineExplorerApp());
    await tester.tap(find.text('Подвал'));
    await settle(tester);
    expect(find.text('Ваш подвал пока пуст'), findsOneWidget);

    await toggleFavorite('2');
    await settle(tester);
    expect(find.text('Viorica de Purcari'), findsOneWidget);

    // Кнопка из пустого состояния ведёт в каталог
    await toggleFavorite('2');
    await settle(tester);
    await tester.tap(find.byType(FilledButton));
    await settle(tester);
    expect(find.byType(TextField), findsOneWidget);
  });
}

/// Картинки-заглушки крутят индикатор бесконечно, поэтому pumpAndSettle не подходит.
Future<void> settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}
