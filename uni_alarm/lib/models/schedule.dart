import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Schedule {
  String discipline_;
  String type_;
  String class_;
  String room_;
  String teacher_;
  int index_;
  int duration_;
  String start_;
  bool isActive;
  late String day_;
  late TimeOfDay starting_time_;
  late String _id;
  late int alarmId;

  void setId(String id){
    _id = id;
  }
  String getId(){
    return _id;
  }
  void setalarmId(int id){
    alarmId= id;
  }
  int getalarmId(){
    return alarmId;
  }


  Schedule(this.discipline_, this.type_, this.class_,this.room_,this.teacher_,this.index_,this.duration_,this.start_,this.isActive)
  {
    switch (index_) {
      case 0:
        day_ = "Monday";
        break;
      case 1:
        day_ = "Tuesday";
        break;
      case 2:
        day_ = "Wednesday";
        break;
      case 3:
        day_ = "Thursday";
        break;
      case 4:
        day_ = "Friday";
        break;
      case 5:
        day_ = "Saturday";
        break;
      default:
        day_ = "";
    }
    Duration time_before = const Duration(minutes: 10);
    String startTimeString = start_.substring(0, 5);
    DateFormat formatter = DateFormat('HH:mm');
    DateTime dateTime = formatter.parse(startTimeString);
    starting_time_ = TimeOfDay.fromDateTime(dateTime.subtract(time_before));
  }

  void draw() {
    print("----------------------------------------------------------");
    print("Na $day_");
    print("Tens uma aula $type_");
    print("Da disciplina de $discipline_");
    print("Na sala $room_");
    print("Com a turma $class_");
    print("O teu professor tem a sigla $teacher_");
    print("Vai ter uma duração de $duration_ minutos e começa às $starting_time_!");
    print("----------------------------------------------------------");
    print("");
  }

}