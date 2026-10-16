import 'package:flutter_test/flutter_test.dart';
import 'package:medassist_ai/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MedAssistApp());

    // Verify that splash screen appears
    expect(find.text('MedAssist AI'), findsOneWidget);
  });
}
