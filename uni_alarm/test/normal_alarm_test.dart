import 'package:uni_alarm/new_alarm.dart';
import 'package:uni_alarm/normal_alarm_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';


//class MockNormalALarm extends Mock implements NormalAlarm {}

void main(){
  testWidgets('button that changes to new alarm page', (WidgetTester tester) async {
    // Build the app and navigate to the Alarms page
    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(home: NormalAlarm()),
      ),
    );

    // Find the button widget
    final buttonFinder = find.byKey(const Key('new_alarm_button'));
    expect(buttonFinder, findsOneWidget);

    //Taps the Button
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    // Verify that the newAlarm page is displayed after the button tap
    expect(find.byType(newAlarm), findsOneWidget);

  });


}