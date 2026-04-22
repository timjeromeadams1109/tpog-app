import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tpog_app/main.dart';

void main() {
  testWidgets('boots to login and sign-in lands on Home', (tester) async {
    await tester.pumpWidget(const TpogApp());
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Login screen shows
    expect(find.text('Sign in'), findsOneWidget);

    // Tap Sign in and verify Home renders without router exception
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Home screen signature widgets
    expect(find.text('The Place of Grace'), findsOneWidget);
    expect(find.text('Grace AI'), findsOneWidget);
    expect(find.text('Community'), findsWidgets);
  });
}
