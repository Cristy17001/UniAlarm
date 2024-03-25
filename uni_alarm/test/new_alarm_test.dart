import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uni_alarm/new_alarm.dart';

void main() {
  testWidgets('SoundOn Test', (WidgetTester tester) async {
    // Build the widget tree with the weekday drawer
    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(home: newAlarm(aux: null,)),
      ),
    );

    newAlarmState state = tester.state(find.byType(newAlarm));

    //Finds the Wanted Buttons
    final switchCardFinder = find.byKey(const Key('soundOn_switchCard'));
    final switchFinder = find.descendant(
      of: switchCardFinder,
      matching: find.byKey(const Key('switch')),
    );


    expect(switchFinder, findsOneWidget);
    expect(state.soundOn, isFalse);


    // Tap the buttons to select soundOn
    await tester.tap(switchFinder);
    await tester.pump();

    expect(state.soundOn, isTrue);
  });
}