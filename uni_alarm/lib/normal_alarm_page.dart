import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uni_alarm/services/database.dart';
import 'package:uni_alarm/Services/notification_service.dart';
import 'package:uni_alarm/models/alarm.dart';
import 'package:uni_alarm/new_alarm.dart';

import 'constants.dart';

class NormalAlarm extends StatefulWidget {
  const NormalAlarm({Key? key}) : super(key: key);

  @override
  State<NormalAlarm> createState() => _NormalAlarmState();
}

class _NormalAlarmState extends State<NormalAlarm> {
  List<Alarm> alarmsList = [];

  @override
  void initState() {
    super.initState();
    rebuildNotifier.addListener(_onAlarmCreation);
  }

  @override
  void dispose() {
    super.dispose();
    rebuildNotifier.removeListener(_onAlarmCreation);
  }

  void _onAlarmCreation() {
    setState(() {});
  }

  Future getAlarmName() async {
    alarmsList = await getAlarms();
  }

  Widget garbajable(Alarm aux) {
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
                  updateSwitch(aux);
                  if (value) {
                    NotificationService.createNormalAlarm(
                        idAlarm: aux.getId(),
                        name: aux.name,
                        sound: aux.soundName,
                        body: aux.body,
                        soundOn: aux.soundOn,
                        vibrationOn: aux.vibrationOn,
                        selectedDays: aux.days,
                        time: aux.timeOfDay
                    );
                  }
                  else {
                    NotificationService.deleteAlarmByKey(aux.getId());
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
              deleteAlarm(aux);
              setState(() {});
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
                "Normal Alarms",
                style: TextStyle(
                    color: isDark ? darkHighlights : lightHighlights,
                    fontSize: 30),
              ),
            ),

            Expanded(
              flex: 7,
              child: SingleChildScrollView(
                child: FutureBuilder(
                    future: getAlarmName(),
                    builder: (context, snapshot) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: alarmsList.isNotEmpty ? List.generate(
                          alarmsList.length,
                              (index) => Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width * 0.10),
                            child: ElevatedButton(
                              onLongPress: () {
                                isLongPressed = !isLongPressed;
                                setState(() {});
                              },
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          newAlarm(aux: alarmsList[index]),
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
                                            Text(alarmsList[index].name,
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                    FontWeight.w400)),
                                            Text(
                                                alarmsList[index].timeOfDay.format(context),
                                                style: TextStyle(
                                                    fontSize: 33,
                                                    fontWeight:
                                                    FontWeight.w400)),
                                          ],
                                        ),
                                        garbajable(alarmsList[index])
                                      ]),
                                ),
                              ),
                            ),
                          ),
                        ): [
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
            //SizedBox(height: MediaQuery.of(context).size.height * 0.45),
            Expanded(
              flex: 1,
              child: IconButton(
                key: const ValueKey('new_alarm_button'),
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
      const newAlarm(aux: null),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}