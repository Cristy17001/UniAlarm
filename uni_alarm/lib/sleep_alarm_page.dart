import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uni_alarm/models/sleepAlarm.dart';
import 'package:uni_alarm/new_sleeping_alarm.dart';
import 'package:uni_alarm/Services/database.dart';
import 'package:uni_alarm/Services/notification_service.dart';


import 'constants.dart';

class SleepAlarmPage extends StatefulWidget {
  const SleepAlarmPage({Key? key}) : super(key: key);

  @override
  State<SleepAlarmPage> createState() => _SleepAlarmPageState();
}

class _SleepAlarmPageState extends State<SleepAlarmPage> {
  List<SleepAlarm> sleepAlarmsList = [];

  @override
  void initState() {
    super.initState();
    rebuildNotifier.addListener(_onSleepAlarmCreation);
  }

  @override
  void dispose() {
    super.dispose();
    rebuildNotifier.removeListener(_onSleepAlarmCreation);
  }

  void _onSleepAlarmCreation() {
    setState(() {});
  }

  Future getSleepAlarmName() async {
    sleepAlarmsList = await getSleepAlarms();
  }

  Widget garbajable(SleepAlarm aux) {
    if (isLongPressed) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(
          children: [
            Switch(
              value: aux.isActive,
              activeColor: lightBackground,
              activeTrackColor: darkDetails,
              inactiveThumbColor: darkBackground,
              inactiveTrackColor: lightDetails,
              onChanged: (bool value) {
                setState(() {
                  updateSleepSwitch(aux);
                  if (value) {
                    NotificationService.createSleepAlarm(
                        alarmId: aux.getId(),
                        title: aux.name,
                        body: aux.body,
                        soundOn: aux.soundOn,
                        soundName: aux.soundName,
                        vibrationOn: aux.vibrationOn,
                        selectedDays: aux.days,
                        wakeUpTime: aux.wakeUpTime,
                        goBedTime: aux.goBedTime,
                    );
                  }
                  else {
                    NotificationService.deleteAlarmByKey(aux.getId() + "WAKEUP");
                    NotificationService.deleteAlarmByKey(aux.getId() + "GOTOBED");
                  }
                });
              },
            ),
            Row(
              children: [
                Text("M",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: aux.days[0]
                            ? (isDark ? darkHighlights : lightHighlights)
                            : darkText)),
                SizedBox(width: 5),
                Text("T",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: aux.days[1]
                            ? (isDark ? darkHighlights : lightHighlights)
                            : darkText)),
                SizedBox(width: 5),
                Text("W",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: aux.days[2]
                            ? (isDark ? darkHighlights : lightHighlights)
                            : darkText)),
                SizedBox(width: 5),
                Text("T",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: aux.days[3]
                            ? (isDark ? darkHighlights : lightHighlights)
                            : darkText)),
                SizedBox(width: 5),
                Text("F",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: aux.days[4]
                            ? (isDark ? darkHighlights : lightHighlights)
                            : darkText)),
                SizedBox(width: 5),
                Text("S",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: aux.days[5]
                            ? (isDark ? darkHighlights : lightHighlights)
                            : darkText)),
                SizedBox(width: 5),
                Text("S",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: aux.days[6]
                            ? (isDark ? darkHighlights : lightHighlights)
                            : darkText)),
              ],
            ),
          ],
        ),
      ]);
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              NotificationService.deleteAlarmByKey(aux.getId());
              deleteSleepAlarm(aux);
              setState(() {});
              // isLongPressed=!isLongPressed;
              // rebuildNotifier.value = !rebuildNotifier.value;
            },
            icon: Image(image: themeImage("bin.png")),
            iconSize: 40,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: isDark ? darkBackground : lightBackground,
        body: FractionallySizedBox(
          widthFactor: 1,
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Image(image: themeImage("arrow_back.png")),
                  iconSize: 40,
                ),
              ],
            ),
            Container(
              child: Text(
                "Sleep Alarms",
                style: TextStyle(
                    color: isDark ? darkHighlights : lightHighlights,
                    fontSize: 30),
              ),
            ),

            Expanded(
              flex: 7,
              child: SingleChildScrollView(
                child: FutureBuilder(
                    future: getSleepAlarmName(),
                    builder: (context, snapshot) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: sleepAlarmsList.isNotEmpty ? List.generate(
                          sleepAlarmsList.length,
                              (index) => Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width * 0.10),
                            child: ElevatedButton(
                              onLongPress: () {
                                isLongPressed = !isLongPressed;
                                rebuildNotifier.value = !rebuildNotifier.value;
                              },
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          newSleepingAlarm(aux: sleepAlarmsList[index]),
                                    ));
                                rebuildNotifier.value = false;
                                needsRebuild = false;
                              },
                              style: ElevatedButton.styleFrom(
                                  foregroundColor:
                                  isDark ? darkText : lightText,
                                  backgroundColor:
                                  isDark ? darkMainCards : lightMainCards,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 3,
                                          color: isDark
                                              ? darkDetails
                                              : lightDetails),
                                      borderRadius: BorderRadius.circular(30))),
                              child: Padding(
                                padding:
                                const EdgeInsets.fromLTRB(10, 20, 10, 20),
                                child: FractionallySizedBox(
                                  widthFactor: 0.8,
                                  child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(sleepAlarmsList[index].name,
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight:
                                                    FontWeight.w400)),
                                            SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                                            Text(
                                                "WakeUp: "+sleepAlarmsList[index].wakeUpTime.format(context),
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight.w400)),
                                            Text(
                                                "Bedtime: "+sleepAlarmsList[index].goBedTime.format(context),
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight.w400)),
                                          ],
                                        ),
                                        garbajable(sleepAlarmsList[index])
                                      ]),
                                ),
                              ),
                            ),
                          ),
                        ):[
                          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                          Center(
                            child: Text(
                              "You don't have any alarms created!",
                              style: TextStyle(
                                color: isDark ? darkText:lightText,
                                fontSize: 28, // Adjust the font size as desired
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                key: const ValueKey('new_sleeping_alarm_button'),
                onPressed: () {
                  Navigator.of(context).push(_createRoute());
                },
                icon: Image(image: themeImage("add_alarm.png")),
                iconSize: 60,
              ),
            ),
          ]),
        ));
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
      const newSleepingAlarm(aux: null),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}