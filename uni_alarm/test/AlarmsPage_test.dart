import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uni_alarm/AlarmsPage.dart';
import 'package:uni_alarm/normal_alarm_page.dart';


void main() {
  testWidgets('button to change pages to normal_alarm_page', (WidgetTester tester) async {
    // Build the app and navigate to the Alarms page
    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(home: Alarms()),
      ),
    );

    // Find the button widget and tap it
    final buttonFinder = find.byKey(const Key('normal_alarm_button'));
    expect(buttonFinder, findsOneWidget);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    // Verify that the NormalAlarm page is displayed after the button tap
    expect(find.byType(NormalAlarm), findsOneWidget);
  });

}
