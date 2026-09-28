import 'package:flutter_test/flutter_test.dart';
import 'package:wine_explorer/widgets/wine_image.dart';

void main() {
  test('полный адрес фото используется как есть', () {
    expect(
      resolveWineImageUrl(' https://example.com/a.jpg '),
      'https://example.com/a.jpg',
    );
  });

  test('пустое фото — заглушка', () {
    expect(resolveWineImageUrl(''), isNull);
  });

  test('путь в бакете без настроенного Supabase — заглушка', () {
    // В тестах SUPABASE_URL не передаётся
    expect(resolveWineImageUrl('purcari/viorica.jpg'), isNull);
  });
}
