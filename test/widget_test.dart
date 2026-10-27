import 'package:flutter_test/flutter_test.dart';

import 'package:catatanku_4342511073/main.dart';

void main() {
  testWidgets('Splash menampilkan nama aplikasi', (WidgetTester tester) async {
    await tester.pumpWidget(const CatatanKuApp());

    expect(find.text('CatatanKu'), findsOneWidget);

    // Biarkan animasi splash selesai agar tidak ada timer yang menggantung.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}