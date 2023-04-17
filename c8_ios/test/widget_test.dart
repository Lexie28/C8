// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:c8_ios/secondmain.dart';
import 'package:c8_ios/main.dart';

void main() {
  testWidgets('First page test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const C8());

    expect(find.text('Circle Eight'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('username'), findsNothing);

    // Tap the '+' icon and trigger a frame.

    // Verify that our counter has incremented.
    //expect(find.text('0'), findsNothing);
    //expect(find.text('1'), findsOneWidget);
  });
}
