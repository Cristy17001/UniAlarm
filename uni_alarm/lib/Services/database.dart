import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:uni_alarm/models/schedule.dart';
import 'package:uni_alarm/models/sleepAlarm.dart';
import '../models/alarm.dart';
import '../constants.dart';


final databaseReference = FirebaseDatabase.instance.ref();
final alarmsRef = databaseReference.child('user/'+ user.uid + '/alarm');
final sleepAlarmsRef = databaseReference.child('user/'+ user.uid + '/sleepAlarm');
final userRef= databaseReference.child('user/' + user.uid);

DatabaseReference saveAlarm(Alarm alarm){
  DatabaseReference id = alarmsRef.push();
  id.set(alarm.toJson());
  return id;
}

DatabaseReference saveSleepAlarm(SleepAlarm sleepAlarm){
  DatabaseReference id = sleepAlarmsRef.push();
  id.set(sleepAlarm.toJson());
  return id;
}

DatabaseReference saveScheduleAlarm(int id_,String discipline_, String type_, String class_, String room_, String teacher_, int index_, int duration_, String start_, bool isActive){
  Map<String,Object> alarmJson = {
    'id': id_,
    'discipline' : discipline_,
    'type' : type_ ,
    'class' : class_,
    'room' : room_,
    'teacher' : teacher_,
    'index' : index_,
    'duration' : duration_,
    'start' : start_,
    'isActive' : isActive};
  DatabaseReference id = databaseReference.child('user/${user.uid}/scheduleAlarm').push();
  id.set(alarmJson);
  return id;
}

Future<List<Alarm>> getAlarms() async {
  List<Alarm> alarms = [];

  DatabaseEvent databaseEvent = await alarmsRef.once();
  DataSnapshot dataSnapshot = databaseEvent.snapshot;
  Map<dynamic, dynamic> data = dataSnapshot.value as Map<dynamic,dynamic>;

  data.forEach((key, value) {
    Alarm alarm = Alarm.fromJson(value);
    alarm.setId(key);
    alarms.add(alarm);
  });
  return alarms;
}

Future<List<SleepAlarm>> getSleepAlarms() async {
  List<SleepAlarm> sleepAlarms = [];

  DatabaseEvent databaseEvent = await sleepAlarmsRef.once();
  DataSnapshot dataSnapshot = databaseEvent.snapshot;
  Map<dynamic, dynamic> data = dataSnapshot.value as Map<dynamic,dynamic>;

  data.forEach((key, value) {
    SleepAlarm sleepAlarm = SleepAlarm.fromJson(value);
    sleepAlarm.setId(key);
    sleepAlarms.add(sleepAlarm);
  });
  return sleepAlarms;
}

Future<List<Schedule>> getScheduleAlarms() async {
  List<Schedule> schedulealarms = [];
  DatabaseEvent databaseEvent = await databaseReference.child('user/${user.uid}/scheduleAlarm').once();
  DataSnapshot dataSnapshot = databaseEvent.snapshot;
  Map<dynamic, dynamic> data = dataSnapshot.value as Map<dynamic,dynamic>;

  data.forEach((key, value) {
    Schedule schedule = Schedule(
        value['discipline'] as String,
        value['type'] as String,
        value['class'] as String,
        value['room'] as String,
        value['teacher'] as String,
        value['index'] as int,
        value['duration'] as int,
        value['start'] as String,
        value['isActive'] as bool
    );
    schedule.setalarmId(value['id']);
    schedule.setId(key);
    schedulealarms.add(schedule);
  });
  return schedulealarms;
}


void updateSwitch(Alarm alarm) async {
  String path = alarm.getId();
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  final Map<String, Object?> updates = {};
  updates["user/${user.uid}/alarm/$path/isActive"] = !alarm.isActive;
  return ref.update(updates);
}

void updateSwitchSchedule(Schedule alarm) async {
  String path= alarm.getId();
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  final Map<String, Object?> updates = {};
  updates["user/${user.uid}/scheduleAlarm/$path/isActive"] = !alarm.isActive;
  return ref.update(updates);
}

void updateSleepSwitch(SleepAlarm sleepAlarm) async {
  String path = sleepAlarm.getId();
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  final Map<String, Object?> updates = {};
  updates["user/${user.uid}/sleepAlarm/$path/isActive"] = !sleepAlarm.isActive;
  return ref.update(updates);
}

void updateAlarm(Alarm alarm, String id) async{
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  final Map<String, Object?> updates = {};
  updates["user/${user.uid}/alarm/$id/vibrationOn"] = alarm.vibrationOn;
  updates["user/${user.uid}/alarm/$id/soundOn"] = alarm.soundOn;
  updates["user/${user.uid}/alarm/$id/soundName"] = alarm.soundName;
  updates["user/${user.uid}/alarm/$id/days"] = alarm.days;
  updates["user/${user.uid}/alarm/$id/name"] = alarm.name;
  updates["user/${user.uid}/alarm/$id/timeOfDay/hour"] = alarm.timeOfDay.hour;
  updates["user/${user.uid}/alarm/$id/timeOfDay/minute"] = alarm.timeOfDay.minute;

  return ref.update(updates);
}


void updateSleepAlarm(SleepAlarm sleepAlarm, String id) async{
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  final Map<String, Object?> updates = {};
  updates["user/${user.uid}/sleepAlarm/$id/vibrationOn"] = sleepAlarm.vibrationOn;
  updates["user/${user.uid}/sleepAlarm/$id/soundOn"] = sleepAlarm.soundOn;
  updates["user/${user.uid}/sleepAlarm/$id/soundName"] = sleepAlarm.soundName;
  updates["user/${user.uid}/sleepAlarm/$id/days"] = sleepAlarm.days;
  updates["user/${user.uid}/sleepAlarm/$id/name"] = sleepAlarm.name;
  updates["user/${user.uid}/sleepAlarm/$id/wakeUpTime/hour"] = sleepAlarm.wakeUpTime.hour;
  updates["user/${user.uid}/sleepAlarm/$id/wakeUpTime/minute"] = sleepAlarm.wakeUpTime.minute;
  updates["user/${user.uid}/sleepAlarm/$id/goBedTime/hour"] = sleepAlarm.goBedTime.hour;
  updates["user/${user.uid}/sleepAlarm/$id/goBedTime/minute"] = sleepAlarm.goBedTime.minute;
  updates["user/${user.uid}/sleepAlarm/$id/sleepingTime/hour"] = sleepAlarm.sleepingTime.hour;
  updates["user/${user.uid}/sleepAlarm/$id/sleepingTime/minute"] = sleepAlarm.sleepingTime.minute;

  return ref.update(updates);
}

void deleteAlarm(Alarm alarm) async {
  String path= alarm.getId();
  DatabaseReference id = databaseReference.child('user/${user.uid}/alarm/$path');
  id.remove();
}

void deleteScheduleAlarms() async{
  DatabaseReference yo =databaseReference.child('user/${user.uid}/scheduleAlarm');
  yo.remove();
}

void deleteSleepAlarm(SleepAlarm sleepAlarm) async {
  String path = sleepAlarm.getId();
  DatabaseReference id = databaseReference.child('user/${user.uid}/sleepAlarm/$path');
  id.remove();
}

void setUsername(String id, String username) {
  Map<String,Object> usernameJson = {'username' : username, 'autoTheme' : false};
  DatabaseReference ref = databaseReference.child('user/$id');
  ref.set(usernameJson);
}
Future<bool> getAutoTheme() async{
  DatabaseEvent ref = await userRef.once();
  DataSnapshot snapshot = ref.snapshot;
  Map<dynamic, dynamic> data = snapshot.value  as Map<dynamic,dynamic>;
  return data['autoTheme'];
}

Future<String> getUsername() async {
  DatabaseEvent ref = await userRef.once();
  DataSnapshot snapshot = ref.snapshot;
  Map<dynamic, dynamic> data = snapshot.value  as Map<dynamic,dynamic>;
  return data['username'];
}
void updateUsername(String username) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  final Map<String, Object?> updates = {};
  updates["user/${user.uid}/username"] = username;
  return ref.update(updates);
}
void updateAutoTheme(bool value) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  final Map<String, Object?> updates = {};
  updates["user/${user.uid}/autoTheme"] = value;
  return ref.update(updates);
}

