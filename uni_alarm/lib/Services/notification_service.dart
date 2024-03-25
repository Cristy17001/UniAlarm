import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni_alarm/models/schedule.dart';

import 'database.dart';

class NotificationService {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'high_importance_channel_group',
          channelKey: 'default_alarm_channel',
          channelName: 'default_alarm_channel',
          channelDescription: 'Sends notifications with sound and vibration but default sound',
          importance: NotificationImportance.High,
          playSound: false,
          enableVibration: false,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'high_importance_channel_group',
          channelGroupName: 'Group 1',
        ),
        NotificationChannelGroup(
          channelGroupKey: 'normal_alarms',
          channelGroupName: 'Normal Alarms',
        )
      ],
      debug: true,
    );

    await AwesomeNotifications().isNotificationAllowed().then(
          (isAllowed) async {
        if (!isAllowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );
  }

  static Future<void> showNotification({
    required final int id,
    required final String channelKey,
    required final String title,
    required final String body,
    required final TimeOfDay timeOfDay,
    required final int weekday,
    final NotificationCategory? category,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout? notificationLayout,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final int? interval,
    final Color? color,
    final String? customSound,
    final String? bigText
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: channelKey,
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout ?? NotificationLayout.Default,
        summary: summary,
        category: category,
        payload: payload,
        bigPicture: bigPicture,
        displayOnBackground: true,
        displayOnForeground: true,
        autoDismissible: false,
        locked: true,
      ),
      actionButtons: actionButtons,
      schedule: scheduled
          ? NotificationCalendar(
        weekday: weekday,
        hour: timeOfDay.hour,
        minute: timeOfDay.minute,
        second: 0,
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        preciseAlarm: true,
        repeats: true
      )
          : null,
    );
  }

  static Future<void> createNormalAlarm({
    required final String idAlarm,
    required final String name,
    required final String sound,
    required final String body,
    required final bool soundOn,
    required final bool vibrationOn,
    required final List<bool> selectedDays,
    required final TimeOfDay time
    }) async {
    await NotificationService.deleteAlarmByKey(idAlarm);

    NotificationChannel channel = NotificationChannel(
      channelGroupKey: "normal_alarms",
      channelKey: idAlarm,
      channelName: '$name normal alarms',
      channelDescription: 'Sends the notifications for the alarm $name in the normal alarms',
      defaultRingtoneType: DefaultRingtoneType.Alarm,
      importance: NotificationImportance.High,
      soundSource: soundOn ? (sound != "" ? sound : null) : null,
      locked: true,
      playSound: soundOn,
      enableVibration: vibrationOn,
      onlyAlertOnce: false,
    );

    // Creates a channel based on the alarm id for that alarm notifications
    AwesomeNotifications().setChannel(channel, forceUpdate: true);

    for (int i = 0; i < selectedDays.length; i++) {
      if (selectedDays[i]) {
        await NotificationService.showNotification(
            channelKey: idAlarm,
            id: NotificationService.createUniqueId(),
            notificationLayout: NotificationLayout.BigText,
            title: name,
            body: body,
            category: NotificationCategory.Alarm,
            scheduled: true,
            timeOfDay: time,
            weekday: i + 1,
            actionButtons: [
              NotificationActionButton(
                  key: 'CANCEL_NOTIFICATION', label: "Dismiss")
            ]
        );
      }
    }
  }

  static Future<void> createScheduleAlarms({
    required final String idSchedules,
    required final List<Schedule> schedules,
    required final bool vibrationOn,
  }) async {
    await NotificationService.deleteAlarmByKey(idSchedules);

    NotificationChannel channel = NotificationChannel(
      channelGroupKey: "Schedule_alarms",
      channelKey: idSchedules,
      channelName: 'Schedule Alarms',
      channelDescription: 'Sends the notifications for Schedule alarm',
      importance: NotificationImportance.High,
      locked: true,
      enableVibration: vibrationOn,
      onlyAlertOnce: false,
    );

    // Creates a channel based on the alarm id for that alarm notifications
    AwesomeNotifications().setChannel(channel, forceUpdate: true);

    for (int i = 0; i < schedules.length; i++) {
      int id=NotificationService.createUniqueId();
      var tag = schedules[i];
      String notificationText = 'Room: ${tag.room_} Duration: ${tag.duration_} min Teacher: ${tag.teacher_}';
      await NotificationService.showNotification(
          channelKey: idSchedules,
          id: id,
          notificationLayout: NotificationLayout.BigText,
          title: "${tag.discipline_} ${tag.type_}",
          body: notificationText,
          category: NotificationCategory.Reminder,
          scheduled: true,
          timeOfDay: tag.starting_time_,
          weekday: tag.index_ + 1,
          actionButtons: [
            NotificationActionButton(
                key: 'CANCEL_NOTIFICATION', label: "Dismiss")
          ]
      );
      schedules[i].setalarmId(id);
      saveScheduleAlarm(id,schedules[i].discipline_,schedules[i].type_,schedules[i].class_,schedules[i].room_,schedules[i].teacher_,schedules[i].index_,schedules[i].duration_,schedules[i].start_,schedules[i].isActive);
    }
  }
  static Future<void> createScheduleAlarm({
    required final int id,
    required final String class_,
    required final String type,
    required final String room,
    required final int duration,
    required final String teacher,
    required final TimeOfDay starting,
    required final int index,
    required final bool vibrationOn,
  }) async {
    await NotificationService.deleteAlarmById(id);

    String notificationText = 'Room: $room Duration: $duration min Teacher: $teacher';
    await NotificationService.showNotification(
        channelKey: "Schedules",
        id: id,
        notificationLayout: NotificationLayout.BigText,
        title: "$class_ $type",
        body: notificationText,
        category: NotificationCategory.Reminder,
        scheduled: true,
        timeOfDay: starting,
        weekday: index+1,
        actionButtons: [
          NotificationActionButton(
              key: 'CANCEL_NOTIFICATION', label: "Dismiss")
        ]
    );
  }

  static Future<void> createSleepAlarm({
    required final String alarmId,
    required final String soundName,
    required final bool soundOn,
    required final List<bool> selectedDays,
    required final bool vibrationOn,
    required final TimeOfDay wakeUpTime,
    required final TimeOfDay goBedTime,
    required final String title,
    required final String body

  }) async {
    String wakeUpId = alarmId + "WAKEUP";
    String goBedId = alarmId + "GOTOBED";
    await NotificationService.deleteAlarmByKey(wakeUpId);
    await NotificationService.deleteAlarmByKey(goBedId);

    NotificationChannel goBedChannel = NotificationChannel(
      channelGroupKey: "sleep_alarms",
      channelKey: goBedId,
      channelName: 'go to bed Alarms',
      channelDescription: 'Sends the notifications for Go to bed',
      defaultRingtoneType: DefaultRingtoneType.Notification,
      importance: NotificationImportance.High,
      locked: true,
      playSound: false,
      enableVibration: true,
      onlyAlertOnce: true,
    );

    NotificationChannel wakeUpChannel = NotificationChannel(
      channelGroupKey: "sleep_alarms",
      channelKey: wakeUpId,
      channelName: 'WakeUp Alarms',
      channelDescription: 'Sends the notifications for Waking up alarm',
      defaultRingtoneType: DefaultRingtoneType.Alarm,
      importance: NotificationImportance.High,
      soundSource: soundOn ? (soundName != "" ? soundName : null) : null,
      locked: true,
      playSound: soundOn,
      enableVibration: vibrationOn,
      onlyAlertOnce: false,
    );

    // Creates a channel based on the alarm id for that alarm notifications
    AwesomeNotifications().setChannel(goBedChannel, forceUpdate: true);
    AwesomeNotifications().setChannel(wakeUpChannel, forceUpdate: true);


    // Go to sleep notifications
    String goBedFormatted = DateFormat('hh:mm a').format(DateTime(2023, 1, 1, goBedTime.hour, goBedTime.minute));
    String wakeUpFormatted = DateFormat('hh:mm a').format(DateTime(2023, 1, 1, wakeUpTime.hour, wakeUpTime.minute));
    for (int i = 0; i < selectedDays.length; i++) {
      if (selectedDays[i]) {
        await NotificationService.showNotification(
            channelKey: goBedId,
            id: NotificationService.createUniqueId(),
            notificationLayout: NotificationLayout.BigText,
            title: "Its $goBedFormatted go to sleep!",
            body: "You will Wake Up at $wakeUpFormatted tomorrow!",
            category: NotificationCategory.Reminder,
            scheduled: true,
            timeOfDay: goBedTime,
            weekday: i+1,
            actionButtons: [
              NotificationActionButton(
                  key: 'CANCEL_NOTIFICATION', label: "Dismiss")
            ]
        );
      }
    }

    // Wake up notifications
    for (int i = 0; i < selectedDays.length; i++) {
      if (selectedDays[i]) {
        await NotificationService.showNotification(
            channelKey: wakeUpId,
            id: NotificationService.createUniqueId(),
            notificationLayout: NotificationLayout.BigText,
            title: title,
            body: body,
            category: NotificationCategory.Alarm,
            scheduled: true,
            timeOfDay: wakeUpTime,
            weekday: i+1,
            actionButtons: [
              NotificationActionButton(
                  key: 'CANCEL_NOTIFICATION', label: "Dismiss")
            ]
        );
      }
    }
  }


  static Future<void> deleteAlarmById(int id) async {
    AwesomeNotifications().cancel(id);
  }

  static Future<void> deleteAlarmByKey(String channelKey) async {
    AwesomeNotifications().cancelNotificationsByChannelKey(channelKey);
    AwesomeNotifications().dismissNotificationsByChannelKey(channelKey);
  }

  static int createUniqueId() {
    int id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
    print("Unique id created is $id");
    return id;
  }
}