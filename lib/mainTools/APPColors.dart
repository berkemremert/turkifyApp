// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:turkify_bem/settingsPageFiles/settingsPageStudent.dart';
import '../settingsPageFiles/settingsPageTutor.dart';

bool isDarkMode = !SettingsPageTutor.getIsDarkMode();
Color white = Colors.white;
Color baseDeepColor = const Color.fromARGB(169, 236, 13, 13);
Color darkRed = const Color.fromARGB(169, 128, 0, 0);
Color baseLightColor = const Color.fromARGB(169, 255, 188, 188);
Color verLightRed = const Color.fromARGB(169, 255, 224, 224);
Color loginPageWarnings = const Color.fromARGB(255, 136, 136, 136);
Color niceDarkBlue = const Color.fromARGB(255, 31, 28, 55);
Color black = Colors.black;
Color darkGrey = Colors.black12;
Color lightGrey = Colors.white30;
Color redAccent = Colors.redAccent;
Color blueAccent = Colors.blueAccent;
Color greenAccent = Colors.greenAccent;
Color red = Colors.red;
Color redOpen = Colors.red.withOpacity(0.75);
Color wordcardTextHighlight = Colors.red.shade100;

Color backGroundColor() {
  if (SettingsPageTutor.isDarkMode || SettingsPageStudent.isDarkMode) {
    return const Color.fromARGB(255, 31, 28, 55);
  } else {
    return Color.fromARGB(255, 255, 250, 250);
  }
  return SettingsPageTutor.isDarkMode ? const Color.fromARGB(255, 31, 28, 55) : Color.fromARGB(255, 255, 250, 250);
}

Color textColor() {
  if (SettingsPageTutor.isDarkMode || SettingsPageStudent.isDarkMode) {
    return Colors.white;
  } else {
    return Colors.black;
  }
  // return SettingsPageTutor.isDarkMode ? Colors.white : Colors.black;
}

Color notificationColor() {
  if (SettingsPageTutor.isDarkMode || SettingsPageStudent.isDarkMode) {
    return Colors.white;
  } else {
    return const Color.fromARGB(255, 128, 0, 0);
  }
  // return SettingsPageTutor.isDarkMode ? Colors.white : const Color.fromARGB(255, 128, 0, 0);
}

Color iconColor() {
  if (SettingsPageTutor.isDarkMode || SettingsPageStudent.isDarkMode) {
    return white;
  } else {
    return black;
  }
  // return SettingsPageTutor.isDarkMode ? lightGrey : const Color.fromARGB(255, 245, 235, 230);
}

Color welcomeColor() {
  if (SettingsPageTutor.isDarkMode || SettingsPageStudent.isDarkMode) {
    return lightGrey;
  } else {
    return const Color.fromARGB(255, 245, 235, 230);
  }
  // return SettingsPageTutor.isDarkMode ? lightGrey : const Color.fromARGB(255, 245, 235, 230);
}

Color endcolor(String text, List<dynamic> langs) {
  if (SettingsPageTutor.isDarkMode || SettingsPageStudent.isDarkMode) {
    return Colors.blueGrey;
  } else {
    return Colors.red.withOpacity(0.75);
  }
  // return langs.contains(text) ? Colors.blueGrey : Colors.red.withOpacity(0.75);
}

Color settingsCardBg(String text, List<dynamic> langs) {
  if (SettingsPageTutor.isDarkMode || SettingsPageStudent.isDarkMode) {
    return Colors.blueGrey;
  } else {
    return Colors.red.withOpacity(0.75);
  }
  // return langs.contains(text) ? Colors.blueGrey : Colors.red.withOpacity(0.75);
}

Color cardColor() {
  if (SettingsPageTutor.isDarkMode || SettingsPageStudent.isDarkMode) {
    return Colors.blueGrey.shade300;
  } else {
    return Colors.grey.shade50;
  }
  // return SettingsPageTutor.isDarkMode ? Colors.white : const Color.fromARGB(255, 128, 0, 0);
}

