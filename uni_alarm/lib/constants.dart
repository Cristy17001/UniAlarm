import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

late User user;
late String username;

bool isLongPressed= true;
bool needsRebuild = true;
ValueNotifier<bool> rebuildNotifier = ValueNotifier<bool>(needsRebuild);

bool imagediff = true;
ValueNotifier<bool> imageNotifier = ValueNotifier<bool>(imagediff);

bool isDark = true;
late bool autoTheme;
ValueNotifier<bool> colorNotifier = ValueNotifier<bool>(isDark);

// Dark Mode
Color darkBackground = const Color.fromRGBO(27, 27, 27, 1.0);
Color darkHighlights = const Color.fromRGBO(255, 0, 2, 1.0);
Color darkMainCards = const Color.fromRGBO(43, 43, 43, 1.0);
Color darkDetails = const Color.fromRGBO(61, 61, 61, 1.0);
Color darkText = const Color.fromRGBO(215, 215, 215, 1.0);
Color darkNavBar = const Color.fromRGBO(51, 51, 51, 1.0);


// Light Mode
Color lightBackground = const Color.fromRGBO(255, 255, 255, 1.0);
Color lightHighlights = const Color.fromRGBO(116, 23, 31, 1.0);
Color lightText = const Color.fromRGBO(180, 30, 31, 1.0);
Color lightSecondaryText = Colors.black;
Color lightMainCards = const Color.fromRGBO(254, 254, 254, 1.0);
Color lightDetails = const Color.fromRGBO(154, 154, 154, 1.0);



AssetImage themeImage(String image) {
  return isDark?AssetImage("assets/darkMode/$image"):AssetImage("assets/lightMode/$image");
}

// Returns true if theme was changed based on the time
// changes time if it has passed 19
void check_automatic_theme(){
  var now = DateTime.now();
  if (now.isAfter(DateTime(now.year, now.month, now.day, 19, 0)) && autoTheme) {
      isDark = true;
  }
  else if (autoTheme) {
      isDark = false;
  }
}
