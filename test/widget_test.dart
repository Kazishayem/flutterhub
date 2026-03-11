import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutterhub/main.dart';

void main() {
  testWidgets('App shows sign in screen when no session', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MyApp(hasSession: false)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsOneWidget);
  });
}
