import 'package:flutter_test/flutter_test.dart';
import 'package:docdoc/main.dart';
import 'package:docdoc/features/auth/presentation/screens/splash_screen.dart';

void main() {
  testWidgets('App starts with SplashScreen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the SplashScreen is rendered.
    expect(find.byType(SplashScreen), findsOneWidget);

    // Settle the 3-second delay timer for navigation
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}
