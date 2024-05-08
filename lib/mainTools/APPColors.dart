// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../settingsPageFiles/settingsPage.dart';

bool isDarkMode = !SettingsPage.getIsDarkMode();
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
Color backGroundColor(){
  return SettingsPage.isDarkMode ? const Color.fromARGB(255, 31, 28, 55) : Colors.white;
}
Color textColor(){
  return SettingsPage.isDarkMode ? Colors.white : Colors.black;
}
Color notificationColor(){
  return SettingsPage.isDarkMode ? Colors.white : const Color.fromARGB(255, 128, 0, 0);
}
Color welcomeColor(){
  return SettingsPage.isDarkMode ? baseDeepColor : const Color.fromARGB(255, 245, 235, 230);

}
