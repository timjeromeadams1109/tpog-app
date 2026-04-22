import 'package:flutter_test/flutter_test.dart';

import 'package:tpog_app/main.dart';

void main() {
  testWidgets('App boots to login', (tester) async {
    await tester.pumpWidget(const TpogApp());
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('Sign in'), findsOneWidget);
  });
}
