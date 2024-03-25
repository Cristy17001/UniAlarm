import 'package:flutter/material.dart';
import 'package:uni_alarm/normal_alarm_page.dart';
import 'package:uni_alarm/schedule_alarm.dart';
import 'package:uni_alarm/sleep_alarm_page.dart';
import 'constants.dart';

class Alarms extends StatefulWidget {
  const Alarms({Key? key}) : super(key: key);

  @override
  State<Alarms> createState() => _AlarmsState();
}

class _AlarmsState extends State<Alarms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: isDark?darkBackground:lightBackground,
        body: FractionallySizedBox(
          widthFactor: 1,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 65),
                  child: Text("Alarms", style: TextStyle(color: isDark?darkHighlights:lightHighlights, fontSize: 30),),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: ElevatedButton(
                    key: Key('normal_alarm_button'),
                    onPressed: (){
                      Navigator.of(context).push(_createRoute());
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: isDark?darkText:lightText,
                        backgroundColor: isDark?darkMainCards:lightMainCards,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 2,
                                color: isDark?darkDetails:lightDetails
                            ),
                            borderRadius: BorderRadius.circular(20)
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                      child: FractionallySizedBox(
                        widthFactor: 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image(image: themeImage("normal_alarm.png")),
                            Text("Normal Alarms", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.10),
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SleepAlarmPage(),
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: isDark?darkText:lightText,
                      backgroundColor: isDark?darkMainCards:lightMainCards,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 2,
                              color: isDark?darkDetails:lightDetails
                          ),
                          borderRadius: BorderRadius.circular(20)
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image(image: themeImage("sleep_alarm.png")),
                          Text("Sleep Alarms", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400)),
                        ],

                      ),
                    ),
                  ),
                ),

              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.10),
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              scheduleAlarm(),
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: isDark?darkText:lightText,
                      backgroundColor: isDark?darkMainCards:lightMainCards,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 2,
                              color: isDark?darkDetails:lightDetails
                          ),
                          borderRadius: BorderRadius.circular(20)
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image(image: themeImage("schedule_alarm.png")),
                          Text("Schedule Alarms", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400)),
                        ],

                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    ));
  }
}

Route _createRoute(){
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const NormalAlarm(),
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

