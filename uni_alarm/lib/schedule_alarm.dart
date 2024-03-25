import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uni_alarm/Services/database.dart';
import 'package:uni_alarm/Services/notification_service.dart';
import 'package:uni_alarm/new_alarm.dart';

import 'package:flutter/material.dart';

import 'constants.dart';
import 'models/schedule.dart';
import 'dart:convert';
import 'dart:io' as io;

import 'package:html/parser.dart';


class scheduleAlarm extends StatefulWidget {
  const scheduleAlarm({Key? key}) : super(key: key);

  @override
  State<scheduleAlarm> createState() => _scheduleAlarmState();
}

class _scheduleAlarmState extends State<scheduleAlarm> {
  List<Schedule> scheduleAlarms= [];
  bool vibrationOn = false;
  void _onVibrationChange(bool newValue) {
    setState(() {
      vibrationOn = newValue;
    });
    print("Vibration value: $vibrationOn\n");
  }

  Future<String> pickFile() async {
    var result = await FilePicker.platform.pickFiles();
    String path = "";
    if (result != null) {
      deleteScheduleAlarms();
      path = result.paths.single!;
      readSchedule(path);

    }

    return path;
  }

  Future getSchedule() async{
    scheduleAlarms=  await getScheduleAlarms();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? darkBackground : lightBackground,
      body: FractionallySizedBox(
        widthFactor: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: Image(image: themeImage("arrow_back.png")),
                  iconSize: 40,
                ),
              ],
            ),
            Container(
                margin: const EdgeInsets.only(top: 25),
                child: Text("Schedule Alarm", style: TextStyle(color: isDark ? darkHighlights : lightHighlights, fontSize: 30))
            ),
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FutureBuilder(
                        future: getSchedule(),
                        builder: (context, snapshot) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: List.generate(
                              scheduleAlarms.length,
                                  (index) => Container(
                                    margin:
                                    EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.05),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                          width: 2,
                                          color: isDark ? darkDetails : lightDetails,
                                        ),
                                      ),
                                      color: isDark ? darkMainCards : lightMainCards,
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                                              child: FractionallySizedBox(
                                                widthFactor: 0.8,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          scheduleAlarms[index].start_.substring(0, 5),
                                                          style: TextStyle(
                                                            fontSize: 22,
                                                            fontWeight: FontWeight.w400,
                                                            color: isDark ? darkText : lightText,
                                                          ),
                                                        ),
                                                        Text(
                                                          scheduleAlarms[index].room_,
                                                          style: TextStyle(
                                                            fontSize: 22,
                                                            fontWeight: FontWeight.w400,
                                                            color: isDark ? darkText : lightText,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(bottom: 8),
                                                          child: Text(
                                                            scheduleAlarms[index].day_,
                                                            style: TextStyle(
                                                              fontSize: 28,
                                                              fontWeight: FontWeight.w400,
                                                              color: isDark ? darkHighlights : lightHighlights,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(bottom: 8),
                                                          child: Text(
                                                            scheduleAlarms[index].discipline_ + scheduleAlarms[index].type_,
                                                            style: TextStyle(
                                                              color: isDark ? darkText : lightText,
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 25,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          scheduleAlarms[index].class_,
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w400,
                                                            color: isDark ? darkText : lightText,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Switch(
                                                          activeColor: isDark ? darkText: lightText,
                                                          inactiveThumbColor: darkBackground,
                                                          inactiveTrackColor: lightDetails,
                                                          value: scheduleAlarms[index].isActive,
                                                            onChanged: (bool value) {
                                                              updateSwitchSchedule(scheduleAlarms[index]);
                                                            setState(() {
                                                              if(value){
                                                                NotificationService.createScheduleAlarm(
                                                                    id: scheduleAlarms[index].getalarmId(),
                                                                    class_: scheduleAlarms[index].discipline_,
                                                                    type: scheduleAlarms[index].type_,
                                                                    room: scheduleAlarms[index].room_,
                                                                    duration: scheduleAlarms[index].duration_,
                                                                    teacher: scheduleAlarms[index].teacher_,
                                                                    starting: scheduleAlarms[index].starting_time_,
                                                                    index: scheduleAlarms[index].index_,
                                                                    vibrationOn: vibrationOn);
                                                              } else {
                                                                NotificationService.deleteAlarmById(scheduleAlarms[index].alarmId);
                                                              }
                                                            });
                                                            },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                          ),

                          );
                        }),
                    Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.10),
                        child: ElevatedButton(
                            onPressed: (){
                              setState(() {pickFile();
                              getSchedule();});
                            },
                            style: ElevatedButton.styleFrom(
                                foregroundColor: isDark ? darkText : lightText,
                                backgroundColor: isDark ? darkMainCards : lightMainCards,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 2,
                                        color: isDark ? darkDetails: lightDetails
                                    ),
                                    borderRadius: BorderRadius.circular(20)
                                )
                            ),
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 20, 20, 20),
                                child: FractionallySizedBox(
                                    widthFactor: 0.8,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Import your weekly schedule",
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                                        ),
                                        Image(
                                          image: themeImage("download.png"),
                                          width: 35,
                                          height: 35,
                                        ),
                                      ],
                                    )
                                )
                            )
                        )
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    SwitchCard(onSwitchChange: _onVibrationChange, image: "vibration.png", text: "Vibration", aux: vibrationOn),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  ],
                ),
              ),
            ),
          ],
        )
      )
    );
  }

  Future<void> readSchedule(String path) async {
    var schedule = List.generate(30, (_) => List.filled(6, ""));
    List<String> hours = [];
    List<Schedule> schedules = [];
    final file = io.File(path);
    String contents = await file.readAsString(encoding: latin1);
    var document;
    var table;

    try {
      document = parse(contents);
      table = document.querySelector('table.horario');

      // Do something with the selected table element
    } catch (e) {
      print('Error parsing HTML: $e');
      return;
    }
    int nRow = 0;
    int nColumn = 0;
    if (table == null) return;
    for (var column in table!.querySelectorAll('tr > td[class]')) {
      if (column.classes.contains('k')) {
        nRow++;
        nColumn = 0;
        hours.add(column.text);
      }
      if (column.classes.contains('horas') && !column.classes.contains('k')) {
        // While the space was already visited
        while (schedule[nRow][nColumn] == 'v') {nColumn++;}
        schedule[nRow][nColumn] = 'v';
      }
      // In case it is a theoretical class propagation need to occur
      else if (column.classes.contains('TE')) {
        int rowspan = int.parse(column.attributes['rowspan']!);
        while (schedule[nRow][nColumn] == 'v') {nColumn++;}
        // Construct the result
        var auxiliar = [];
        String result = "Teorica ${rowspan*30}min";
        for (var data in column.querySelectorAll('a')) {
          auxiliar.add(data);
          result += '-${data.text}';
        }


        Schedule alarm = Schedule(auxiliar[0].text, "(T)", auxiliar[1].text, auxiliar[2].text, auxiliar[3].text, nColumn, rowspan*30, hours[nRow-1], true);
        schedules.add(alarm);
        alarm.draw();
        // Assign the value inside the schedule
        schedule[nRow][nColumn] = result;

        // Propagate the rowSpan marking as visited
        for (int i = nRow+1; i < nRow+rowspan; i++) {
          schedule[i][nColumn] = 'v';
        }
      }
      // In case it is a laboratorial propagation need to occur
      else if (column.classes.contains('PL')) {
        int rowspan = int.parse(column.attributes['rowspan']!);
        while (schedule[nRow][nColumn] == 'v') {nColumn++;}

        // Construct the result
        var auxiliar = [];
        String result = "Laboratoria ${rowspan*30}min";
        for (var data in column.querySelectorAll('a')) {
          auxiliar.add(data);
          result += '-${data.text}';
        }

        Schedule alarm = Schedule(auxiliar[0].text, "(PL)", auxiliar[1].text, auxiliar[2].text, auxiliar[3].text, nColumn, rowspan*30, hours[nRow-1],true);
        schedules.add(alarm);
        alarm.draw();

        // Assign the value inside the schedule
        schedule[nRow][nColumn] = result;

        // Propagate the rowSpan marking as visited
        for (int i = nRow+1; i < nRow+rowspan; i++) {
          schedule[i][nColumn] = 'v';
        }
      }
      // In case it is a practical class propagation need to occur
      else if (column.classes.contains('TP')) {
        int rowspan = int.parse(column.attributes['rowspan']!);
        while (schedule[nRow][nColumn] == 'v') {nColumn++;}

        // Construct the result
        var auxiliar = [];
        String result = "Pratica " + (rowspan*30).toString() + "min";
        for (var data in column.querySelectorAll('a')) {
          auxiliar.add(data);
          result += '-${data.text}';
        }

        Schedule alarm = Schedule(auxiliar[0].text, "(TP)", auxiliar[1].text, auxiliar[2].text, auxiliar[3].text, nColumn, rowspan*30, hours[nRow-1],true);
        schedules.add(alarm);
        alarm.draw();

        // Assign the value inside the schedule
        schedule[nRow][nColumn] = result;

        // Propagate the rowSpan marking as visited
        for (int i = nRow+1; i < nRow+rowspan; i++) {
          schedule[i][nColumn] = 'v';
        }
      }
      else {nColumn--;}
      nColumn++;
    }
    NotificationService.createScheduleAlarms(idSchedules: "Schedules", schedules: schedules, vibrationOn: vibrationOn);
  }
}

