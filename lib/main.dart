import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'basicLoginPage/screens/login_screen.dart';
import 'dashboard_screen.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:turkify_bem/EntryScreen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';


Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform );
  await FirebaseAppCheck.instance.activate();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EntryScreen(),
    );
  }
}