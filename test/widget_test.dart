// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gaymerstreams/app.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(new App());
    //Verify widgets present
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Add a Twitch Gaymer'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byIcon(Icons.send), findsOneWidget);

    //
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'FakeUserName');
    await tester.pump();
    expect(find.text('FakeUserName'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();
    expect(find.text('FakeUserName'), findsNothing); //verify input cleared
    expect(find.text('Add a Twitch Gaymer'), findsOneWidget); //verify hint text restored
  });

}
