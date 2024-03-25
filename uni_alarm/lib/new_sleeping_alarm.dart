import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:uni_alarm/models/sleepAlarm.dart';
import 'package:uni_alarm/sound_page.dart';

import 'Services/database.dart';
import 'constants.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:uni_alarm/Services/notification_service.dart';

import 'models/alarm.dart';

class newSleepingAlarm extends StatefulWidget {
  final SleepAlarm? aux;
  const newSleepingAlarm({Key? key,required this.aux}) : super(key: key);

  @override
  State<newSleepingAlarm> createState() => newSleepingAlarmState();
}

class newSleepingAlarmState extends State<newSleepingAlarm> {
  bool isActive = true;
  SleepAlarm? aux;
  bool edit = false;
  String idAlarm = "MUSTBEUNIQUEIDSLEEP";
  String name = "Sleep";
  DateTime sleepingTime = DateTime(2016, 5, 10, 8, 00);

  // Must have format "resource://raw/sound_name  without the .wav file name in the raw folder must have res_ at the start but not when declaring the sound"
  String sound = "";
  String body = "";
  TimeOfDay _time = const TimeOfDay(hour: 7, minute: 15);
  List<bool> _selectedDays = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  bool isEditing = false;
  final _controller = TextEditingController();

  bool soundOn = false;
  bool vibrationOn = false;

  void handleString(String fetchedString) {
    setState(() {
      sound = fetchedString;
    });
    print("Sound: $sound");
  }


  // Gives the widget depending on if it is being edited or not
  Widget editLabel() {
    if (isEditing) {
      return TextField(
        maxLength: 15,
        controller: _controller,
        autofocus: true,
        style: TextStyle(
          color: isDark ? darkText : lightText,
          fontSize: 25,
          fontWeight: FontWeight.w300,
        ),
        onSubmitted: (String value) {
          setState(() {
            name = value;
            isEditing = false;
          });
        },
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
            counterText: "",
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderSide:
              BorderSide(color: isDark ? lightHighlights : lightHighlights),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: InkWell(
                onTap: () {
                  setState(() {
                    name = _controller.text;
                    isEditing = false;
                  });
                },
                child: Icon(Icons.check, color: isDark ? darkText : lightText),
              ),
            ),
            suffixIconColor: Colors.red),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child:
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            name,
            style: TextStyle(
                color: isDark ? darkText : lightText,
                fontSize: 25,
                fontWeight: FontWeight.w300),
          ),
          InkWell(
              onTap: () {
                setState(() {
                  _controller.text = name;
                  isEditing = true;
                });
              },
              child: Icon(Icons.edit, color: isDark ? darkText : lightText))
        ]),
      );
    }
  }

  // Customized TimePicker Widget
  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
        context: context,
        initialTime: _time,
        builder: (context, child) {
          final colorScheme = isDark
              ? const ColorScheme.dark(
            primary: Color(0xFFFF0002), // Cancel, Ok and selected color
          )
              : const ColorScheme.light(
            primary: Color(0xFFFF0002), // Cancel, Ok and selected color
          );
          final backgroundColor =
          isDark ? const Color(0xFF1B1B1B) : Colors.white;
          final hourMinuteTextColor = isDark ? Colors.white : Colors.black;
          final dayPeriodTextColor = isDark ? Colors.white : Colors.black;
          final entryModeIconColor =
          isDark ? const Color(0xFFB41E1F) : Colors.black;
          final helpTextStyle = TextStyle(
            // Select time textStyle
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFFFF0002) : Colors.black);

          return Theme(
            data: ThemeData.from(colorScheme: colorScheme),
            child: TimePickerTheme(
              data: TimePickerThemeData(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    side: BorderSide(color: Colors.transparent)),
                backgroundColor: backgroundColor,
                hourMinuteTextColor: hourMinuteTextColor,
                dialBackgroundColor: Colors.transparent,
                dayPeriodTextColor: dayPeriodTextColor,
                entryModeIconColor: entryModeIconColor,
                helpTextStyle: helpTextStyle,
              ),
              child: child!,
            ),
          );
        });
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }

  TimeOfDay calculateSleepTime() {
    Duration sleepingDuration = Duration(hours: sleepingTime.hour, minutes: sleepingTime.minute);
    DateTime wakeUpDateTime = DateTime(2023, 5, 24, _time.hour, _time.minute);
    DateTime bedTimeDateTime = wakeUpDateTime.subtract(sleepingDuration);

    TimeOfDay bedTime = TimeOfDay(hour: bedTimeDateTime.hour, minute: bedTimeDateTime.minute);

    return bedTime;
  }

  // Notification Manager
  Future<void> _notificationManager(String body) async {
    NotificationService.deleteAlarmByKey(idAlarm + "WAKEUP");
    NotificationService.deleteAlarmByKey(idAlarm + "GOTOBED");
    NotificationService.createSleepAlarm(
        alarmId: idAlarm,
        title: name,
        body: body,
        soundName: sound,
        soundOn: soundOn,
        vibrationOn: vibrationOn,
        selectedDays: _selectedDays,
        wakeUpTime: _time,
        goBedTime: calculateSleepTime(),
    );
  }

  // Select or unselect the day
  void _selectDay(int day) {
    _selectedDays[day] = !_selectedDays[day];
  }

  // Build and logic to select the day
  Widget weekdayDrawer(int index, String letter) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectDay(index);
        });
      },
      borderRadius: BorderRadius.circular(15),
      child: CircleAvatar(
        radius: 15,
        backgroundColor: _selectedDays[index]
            ? (isDark ? darkHighlights : lightText)
            : Colors.transparent,
        child: Text(letter,
            style: TextStyle(
                color: isDark ? darkText : lightSecondaryText,
                fontSize: 25)),
      ),
    );
  }

  // Retrieve Switch values
  void _onSoundChange(bool newValue) {
    setState(() {
      soundOn = newValue;
    });
    print("Sound value: $soundOn\n");
  }
  void _onVibrationChange(bool newValue) {
    setState(() {
      vibrationOn = newValue;
    });
    print("Vibration value: $vibrationOn\n");
  }

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    aux = widget.aux;
    edit = aux != null;
    if (edit) {
      name = aux!.name;
      _selectedDays = aux!.days;
      _time = aux!.wakeUpTime;
      sleepingTime = DateTime(2023, 1, 1, aux!.sleepingTime.hour, aux!.sleepingTime.minute);
      soundOn = aux!.soundOn;
      vibrationOn = aux!.vibrationOn;
      idAlarm= aux!.getId();
      body=aux!.body;
      sound = aux!.soundName;
    }
    super.initState();
  }

  void _showSleepingDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: MediaQuery.of(context).size.height * 0.30,
        // Provide a background color for the popup.
        color: isDark ? darkMainCards : lightMainCards,
        // Use a SafeArea widget to avoid system overlaps.

        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String timeFormatted = DateFormat('hh:mm').format(DateTime(2023, 1, 1, _time.hour, _time.minute));
    String timedayFormatted = DateFormat('a').format(DateTime(2023, 1, 1, _time.hour, _time.minute));
    String formattedSleepingTime = DateFormat('HH:mm').format(sleepingTime);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: isDark ? darkBackground : lightBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.05,
          ), // Full width width and top space
          FractionallySizedBox(
            widthFactor: 0.8,
            child: Card(
              color: isDark ? darkMainCards : lightMainCards,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1.5,
                    color: isDark ? darkDetails : lightDetails,
                  ),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                child: editLabel(),
              ),
            ),
          ),
          Card(
            color: isDark
                ? darkMainCards.withAlpha(75)
                : lightMainCards.withAlpha(225),
            shape: CircleBorder(
                side: BorderSide(
                  width: 1.5,
                  color: isDark ? darkDetails : lightDetails,
                )),
            child: Padding(
              padding:
              EdgeInsets.all(MediaQuery.of(context).size.height * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  TextButton(
                    onPressed: _selectTime,
                    child: Text(
                      timeFormatted,
                      style: TextStyle(
                          color: isDark ? darkText : lightSecondaryText,
                          fontSize: 45,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Card(
                    color: isDark
                        ? darkMainCards.withAlpha(255)
                        : lightMainCards.withAlpha(150),
                    shape: const OvalBorder(),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(50, 25, 50, 25),
                      child: Text(timedayFormatted,
                          style: TextStyle(
                              color: isDark ? darkText : lightSecondaryText,
                              fontSize: 30,
                              fontWeight: FontWeight.w400)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Card(
              color: isDark ? darkMainCards : lightMainCards,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                      width: 1.5, color: isDark ? darkDetails : lightDetails)),
              child: FractionallySizedBox(
                widthFactor: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    KeyedSubtree(key: const ValueKey('monday_button'), child: weekdayDrawer(0, "M")),
                    KeyedSubtree(key: const ValueKey('tuesday_button'), child: weekdayDrawer(1, "T")),
                    KeyedSubtree(key: const ValueKey('wednesday_button'), child: weekdayDrawer(2, "W")),
                    KeyedSubtree(key: const ValueKey('thursday_button'), child: weekdayDrawer(3, "T")),
                    KeyedSubtree(key: const ValueKey('friday_button'), child: weekdayDrawer(4, "F")),
                    KeyedSubtree(key: const ValueKey('saturday_button'), child: weekdayDrawer(5, "S")),
                    KeyedSubtree(key: const ValueKey('sunday_button'), child: weekdayDrawer(6, "S")),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          a(key: const ValueKey('soundOn_switchCard'),onStringFetched: handleString,onSwitchChange: _onSoundChange,image: "sound.png", text: "Sound",aux: soundOn,sound: sound,),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          SwitchCard(onSwitchChange: _onVibrationChange, image: "vibration.png", text: "Vibration", aux: vibrationOn),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => _showSleepingDialog(
              CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                          fontSize: 20,
                          color: isDark ? darkText : lightSecondaryText
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    initialDateTime: sleepingTime,
                    mode: CupertinoDatePickerMode.time,
                    use24hFormat: true,
                    // This is called when the user changes the time.
                    onDateTimeChanged: (DateTime newTime) {
                      setState(() => sleepingTime = newTime);
                    },
                  ),
              ),
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.78,
              height: MediaQuery.of(context).size.height * 0.08,
              child: Card(
                color: isDark ? darkMainCards : lightMainCards,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(
                        width: 1.5, color: isDark ? darkDetails : lightDetails)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Sleeping Time:  ", style: TextStyle(color: isDark ? darkText : lightText, fontSize: 25,
                    fontWeight: FontWeight.w300)),
                    Text(formattedSleepingTime, style: TextStyle(color: isDark ? darkText : lightText, fontSize: 24,
                        fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: FractionallySizedBox(
              widthFactor: 0.6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      key: const Key('return_button'),
                      onPressed: () {
                        if (isEditing) {
                          setState(() {
                            _selectedDays = aux!.days;
                          });
                        }
                        rebuildNotifier.value = !rebuildNotifier.value;
                        needsRebuild = !needsRebuild;
                        Navigator.pop(context);
                      },
                      icon: Image(image: themeImage("cross.png"))),
                  IconButton(
                      onPressed: () {
                        bool selectedAtLeastOneDay = false;
                        for (bool day in _selectedDays) {
                          if (day) selectedAtLeastOneDay = true;
                        }
                        if (selectedAtLeastOneDay) {
                          body = "$timeFormatted $timedayFormatted";
                          _notificationManager(body);
                          var alarm = SleepAlarm(
                            name,
                            _selectedDays,
                            _time,
                            calculateSleepTime(),
                            TimeOfDay(hour: sleepingTime.hour, minute: sleepingTime.minute),
                            soundOn,
                            vibrationOn,
                            isActive,
                            soundOn ? sound : "",
                            body,
                          );
                          if (edit) {
                            alarm.setId(idAlarm);
                            alarm.isActive = false;
                            updateSleepAlarm(alarm, idAlarm);
                            updateSleepSwitch(alarm);
                          } else {
                            saveSleepAlarm(alarm);
                          }
                          Navigator.pop(context);
                          isLongPressed = true;
                        }
                        else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor:  isDark ? darkBackground : lightBackground,
                                title: Text('You must select at least one day!', style: TextStyle(color: isDark ? darkText : lightText)),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {Navigator.of(context).pop();},
                                    child: Text("Ok", style: TextStyle(color: isDark ? darkHighlights : lightHighlights)),
                                  )
                                ],
                              );
                            },
                          );
                        }
                        rebuildNotifier.value = !rebuildNotifier.value;
                        needsRebuild = !needsRebuild;
                      },
                      icon: Image(image: themeImage("check.png"))),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SwitchCard extends StatefulWidget {
  final String image;
  final String text;
  final Function(bool) onSwitchChange;
  final bool aux;

  const SwitchCard({super.key, required this.onSwitchChange ,required this.image, required this.text, required  this.aux});

  @override
  State<SwitchCard> createState() => _SwitchCardState();
}

class _SwitchCardState extends State<SwitchCard> {
  bool _switchValue = false;
  @override
  void initState() {
    _switchValue=widget.aux;
    super.initState();
  }

  void _onSwitchValueChanged(bool newValue) {
    setState(() {
      _switchValue = newValue;
    });
    widget.onSwitchChange(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.08,
      width: MediaQuery.of(context).size.width * 0.8,

      child: Card(
        color: isDark ? darkMainCards : lightMainCards,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
                width: 1.5, color: isDark ? darkDetails : lightDetails)),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(widget.text,
                      style: TextStyle(
                          color: isDark ? darkText : lightSecondaryText,
                          fontSize: 25,
                          fontWeight: FontWeight.w300)),
                  SizedBox(width: MediaQuery.of(context).size.height * 0.02),
                  Image(image: themeImage(widget.image)),
                ],
              ),
              Switch(
                key: const ValueKey('switch'),
                value: _switchValue,
                onChanged: _onSwitchValueChanged,
                activeColor: isDark ? darkText : lightText,
                inactiveThumbColor: isDark ? darkText : lightSecondaryText,
                inactiveTrackColor: isDark ? const Color(0xFF333333) : lightDetails,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class a extends StatefulWidget {
  final String image;
  final String text;
  final Function(bool) onSwitchChange;
  final void Function(String) onStringFetched; // Callback function
  final bool aux;
  final String sound;

  const a({super.key,required this.onStringFetched,required this.onSwitchChange ,required this.image, required this.text, required  this.aux,required this.sound});

  @override
  State<a> createState() => _aState();
}

class _aState extends State<a> {
  bool _switchValue = false;
  @override
  void initState() {
    _switchValue=widget.aux;
    super.initState();
  }


  Route _createRoute(String sound) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          StandardSounds(alarmSound: sound),
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


  void _onSoundChange(String sound) {
    widget.onStringFetched(sound);
  }

  void _onSwitchValueChanged(bool newValue) {
    setState(() {
      _switchValue = newValue;
    });
    widget.onSwitchChange(newValue);
  }

  @override
  Widget build(BuildContext context) {
    var sound = widget.sound;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width * 0.78,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? darkMainCards : lightMainCards,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              width: 1.5,
              color: isDark ? darkDetails : lightDetails,
            ),
          ),
        ),
        onPressed: () async {
          String? tempSound = await Navigator.of(context).push(_createRoute(sound)) as String?;
          if (tempSound != null) {
            sound = tempSound;
          }
          _onSoundChange(sound);
        },// Handle the button press in _onCardPressed function
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    widget.text,
                    style: TextStyle(
                      color: isDark ? darkText : lightSecondaryText,
                      fontSize: 25,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Image(image: themeImage(widget.image)),
                ],
              ),
              Switch(
                key: const ValueKey('switch'),
                value: _switchValue,
                onChanged: _onSwitchValueChanged,
                activeColor: isDark ? darkText : lightText,
                inactiveThumbColor: isDark ? darkText : lightSecondaryText,
                inactiveTrackColor: isDark ? const Color(0xFF333333) : lightDetails,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
