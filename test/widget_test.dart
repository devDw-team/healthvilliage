// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:health_village/app.dart';

void main() {
  testWidgets('Health Village app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: HealthVillageApp(),
      ),
    );

    // Verify that the app starts with splash screen
    expect(find.text('헬스빌리지'), findsOneWidget);
    
    // Wait for splash screen to complete and navigate to home
    await tester.pumpAndSettle(const Duration(seconds: 3));
    
    // Verify that we've navigated to home screen
    expect(find.text('홈'), findsOneWidget);
  });
}
