import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class SleepAlarm {
  String name;
  List<bool> days;
  TimeOfDay wakeUpTime;
  TimeOfDay goBedTime;
  TimeOfDay sleepingTime;
  bool soundOn;
  bool vibrationOn;
  bool isActive;
  String soundName;
  String body;
  late String _id;

  SleepAlarm(
      this.name,
      this.days,
      this.wakeUpTime,
      this.goBedTime,
      this.sleepingTime,
      this.soundOn,
      this.vibrationOn,
      this.isActive,
      this.soundName,
      this.body);

  void setId(String id) {
    _id = id;
  }

  String getId(){
    return _id;
  }

  Map<String, int> timeOfdayConverter(TimeOfDay timeofday){
    TimeOfDay time = timeofday;
    Map<String, int> timeMap = {
      'hour': time.hour,
      'minute': time.minute,
    };
    return timeMap;
  }


  Map<String,dynamic> toJson(){
    Map<String, int> wakeUpTimeMap = timeOfdayConverter(wakeUpTime);
    Map<String, int> goBedTimeMap = timeOfdayConverter(goBedTime);
    Map<String, int> sleepingTimeMap = timeOfdayConverter(sleepingTime);

    return {
      'name' : name,
      'days' : days,
      'wakeUpTime' : wakeUpTimeMap,
      'goBedTime' : goBedTimeMap,
      'sleepingTime' : sleepingTimeMap,
      'soundOn' : soundOn,
      'vibrationOn' : vibrationOn,
      'isActive' : isActive,
      'soundName' : soundName,
      'body' : body,
    };
  }

  factory SleepAlarm.fromJson(Map<dynamic,dynamic> json) {
    List<dynamic> daysList = json['days'];
    List<bool> days = daysList.map((day) => day as bool).toList();

    Map<String, dynamic> wakeUpTimeMap =
    Map<String, dynamic>.from(json['wakeUpTime']);
    TimeOfDay wakeUpTime = TimeOfDay(
      hour: wakeUpTimeMap['hour'],
      minute: wakeUpTimeMap['minute'],
    );
    Map<String, dynamic> goBedTimeMap =
    Map<String, dynamic>.from(json['goBedTime']);
    TimeOfDay goBedTime = TimeOfDay(
      hour: goBedTimeMap['hour'],
      minute: goBedTimeMap['minute'],
    );

    Map<String, dynamic> sleepingTimeMap =
    Map<String, dynamic>.from(json['sleepingTime']);
    TimeOfDay sleepingTime = TimeOfDay(
      hour: sleepingTimeMap['hour'],
      minute: sleepingTimeMap['minute'],
    );

    return SleepAlarm(
      json['name'],
      days,
      wakeUpTime,
      goBedTime,
      sleepingTime,
      json['soundOn'],
      json['vibrationOn'],
      json['isActive'],
      json['soundName'],
      json['body'],
    );
  }
}


