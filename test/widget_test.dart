// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ciandcd/main.dart';

void main() {
  testWidgets('App displays CI/CD demo content', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app displays the expected text
    expect(find.text('CI/CD Demo'), findsOneWidget);
    expect(find.text('Test CI/CD'), findsOneWidget);
    expect(find.text('hello world'), findsOneWidget);

    // Verify that the AppBar is present
    expect(find.byType(AppBar), findsOneWidget);
  });
}
