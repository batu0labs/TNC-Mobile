import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/main.dart';

void main() {
  testWidgets('Mini Katalog ana sayfası açılır', (WidgetTester tester) async {
    // Uygulamayı başlat.
    await tester.pumpWidget(const CatalogApp());

    // Arayüzü oluştur.
    await tester.pump();

    // Ana sayfadaki bileşenleri doğrula.
    expect(find.text('Mini Katalog'), findsOneWidget);
    expect(find.text('Ürünleri Gör'), findsOneWidget);
  });
}
