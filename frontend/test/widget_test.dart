import 'package:flutter_test/flutter_test.dart';
import 'package:quentiq/app.dart';

void main() {
  testWidgets('Quentiq app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const QuentiqApp());
    await tester.pump();
    expect(find.text('Quentiq'), findsOneWidget);
  });
}
