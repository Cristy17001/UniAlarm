import 'package:flutter/material.dart';
import 'constants.dart';

class StandardSounds extends StatefulWidget {
  final String alarmSound;
  const StandardSounds({Key? key,required this.alarmSound}) : super(key: key);

  @override
  State<StandardSounds> createState() => _StandardSoundsState();
}

class _StandardSoundsState extends State<StandardSounds> {
  String _selectedSound = "";

  void valueBySound(String soundToFind) {
    setState(() {
      _selectedSound = soundToFind;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedSound = widget.alarmSound;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: isDark ? darkBackground : lightBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 65),
            child: Text("Standard Sounds", style: TextStyle(color: isDark?darkHighlights:lightHighlights, fontSize: 40),),
          ),
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.05,
          ), // Full width width and top space

          Card(
            margin: const EdgeInsets.only(top: 40),
            shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: isDark?darkDetails:lightDetails,
                ),
                borderRadius: BorderRadius.circular(20.0)),
            color: isDark?darkMainCards:lightMainCards,
            child: Container(
              height: 400,
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
              child: FractionallySizedBox(
                  widthFactor: 0.9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Transform.scale(
                            scale: 1.5,
                            child: Radio<String>(
                              value: 'resource://raw/annoyingalert',
                              groupValue: _selectedSound,
                              onChanged: (value){
                                setState(() {
                                  valueBySound(value!);
                                });
                              },
                              fillColor: MaterialStateColor.resolveWith((states) => isDark ? darkText : lightText,),
                              focusColor: MaterialStateColor.resolveWith((states) => isDark ? darkText : lightText,),

                            ),
                          ),
                          Text("Annoying Alert",style: TextStyle(color:isDark ? darkText : lightText,fontSize: 30 )),
                        ],),

                      Row(
                        children: [
                          Transform.scale(
                            scale: 1.5,
                            child: Radio<String>(
                              value: 'resource://raw/notification',
                              groupValue: _selectedSound,
                              onChanged: (value){
                                setState(() {

                                  valueBySound(value!);
                                },);
                              },
                              fillColor: MaterialStateColor.resolveWith((states) => isDark ? darkText : lightText,),
                              focusColor: MaterialStateColor.resolveWith((states) => isDark ? darkText : lightText,),
                            ),
                          ),
                          Text("Notification Alarm",style: TextStyle(color:isDark ? darkText : lightText,fontSize: 30)),
                        ],),
                      Row(
                        children: [
                          Transform.scale(
                            scale: 1.5,
                            child: Radio<String>(value: 'resource://raw/rooster',
                              groupValue: _selectedSound,
                              onChanged: (value){
                                setState(() {

                                  valueBySound(value!);
                                });
                              },
                              fillColor: MaterialStateColor.resolveWith((states) => isDark ? darkText : lightText,),
                              focusColor: MaterialStateColor.resolveWith((states) => isDark ? darkText : lightText,),
                            ),
                          ),
                          Text("Rooster",style: TextStyle(color:isDark ? darkText : lightText,fontSize: 30),),
                        ],),
                      Row(
                        children: [
                          Transform.scale(
                            scale: 1.5,
                            child: Radio<String>(value: 'resource://raw/sci_fi',
                              groupValue: _selectedSound,
                              onChanged: (value){
                                setState(() {
                                  valueBySound(value!);
                                });
                              },
                              fillColor: MaterialStateColor.resolveWith((states) => isDark ? darkText : lightText,),
                              focusColor: MaterialStateColor.resolveWith((states) => isDark ? darkText : lightText,),
                            ),
                          ),
                          Text("Sci-fi",style: TextStyle(color:isDark ? darkText : lightText,fontSize: 30),),
                        ],),
                      Row(
                        children: [
                          Transform.scale(
                            scale: 1.5,
                            child: Radio<String>(value: '',
                              groupValue: _selectedSound,
                              onChanged: (value){
                                setState(() {
                                  valueBySound(value!);
                                });
                              },
                              fillColor: MaterialStateColor.resolveWith((states) => isDark ? darkText : lightText,),
                              focusColor: MaterialStateColor.resolveWith((states) => isDark ? darkText : lightText,),
                            ),
                          ),
                          Text("Default",style: TextStyle(color:isDark ? darkText : lightText,fontSize: 30),),
                        ],),
                    ],
                  )
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.10),

          Expanded(
            child: FractionallySizedBox(
              widthFactor: 0.6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      key: const Key('return_button'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Image(image: themeImage("cross.png"))),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context,_selectedSound);
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
