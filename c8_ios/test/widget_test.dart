// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:c8_ios/main.dart';

void main() {
  testWidgets('First page test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(C8());

    // Se att korrekta widgetar visas
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Popular items'), findsOneWidget);
    expect(find.text('Clothes'), findsOneWidget);
    expect(find.text('username'), findsNothing);

    await tester.tap(find.byIcon(Icons.add_circle_outline));

    //expect(find.widgetWithIcon(), findsOneWidget);
  });
}
