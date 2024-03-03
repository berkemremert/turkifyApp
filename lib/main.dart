import 'package:firebase_core/firebase_core.dart';
import 'package:turkify_bem/APPColors.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:turkify_bem/EntryScreen.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform );
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
