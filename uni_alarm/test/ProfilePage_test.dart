import 'package:flutter/material.dart';
import 'package:uni_alarm/ProfilePage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uni_alarm/constants.dart';

void main() {

  testWidgets('Switch to change theme', (WidgetTester tester) async {
    // Build the app and pump it
    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(home: Profile()),
      ),
    );

    // Find the Switch widget
    final switchFinder = find.byKey(const Key('DarkTheme_switch'));
    expect(switchFinder, findsOneWidget);

    //Checks if dark theme is true
    expect(isDark, isTrue);

    // Toggle the switch
    await tester.tap(switchFinder);
    await tester.pump();

    //Checks if dark theme is false
    expect(isDark, isFalse);

  });
}

