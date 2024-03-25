import 'package:flutter/material.dart';


class Alarm {
  String name;
  List<bool> days;
  TimeOfDay timeOfDay;
  bool soundOn;
  bool vibrationOn;
  bool isActive;
  String soundName;
  String body;
  late String _id;


  Alarm(this.name,this.days,this.timeOfDay,this.soundOn,this.vibrationOn,this.isActive,this.soundName,this.body);

  void setId(String id){
    _id = id;
  }
  String getId(){
    return _id;
  }

  Map<String, int> timeOfdayConverter(){
    TimeOfDay time = timeOfDay;
    Map<String, int> timeMap = {
      'hour': time.hour,
      'minute': time.minute,
    };
    return timeMap;
  }


  Map<String,dynamic> toJson(){
    Map<String, int> timeOfDayMap = timeOfdayConverter();
    return {
      'name' : name,
      'days' : days,
      'timeOfDay' : timeOfDayMap,
      'soundOn' : soundOn,
      'vibrationOn' : vibrationOn,
      'isActive' : isActive,
      'soundName' : soundName,
      'body' : body,
    };
  }

  factory Alarm.fromJson(Map<dynamic,dynamic> json) {
    List<dynamic> daysList = json['days'];
    List<bool> days = daysList.map((day) => day as bool).toList();

    Map<String, dynamic> timeOfDayMap =
    Map<String, dynamic>.from(json['timeOfDay']);
    TimeOfDay timeOfDay = TimeOfDay(
      hour: timeOfDayMap['hour'],
      minute: timeOfDayMap['minute'],
    );

    return Alarm(
      json['name'],
      days,
      timeOfDay,
      json['soundOn'],
      json['vibrationOn'],
      json['isActive'],
      json['soundName'],
      json['body'],
    );
  }
}

