import 'package:flutter/material.dart';
import 'presentation/pages/home/view/home.dart';

void listingScreenPage() {
  runApp(const listingScreen());
}

class listingScreen extends StatelessWidget {
  const listingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Raleway',
      ),
      themeMode: ThemeMode.light,
      darkTheme: ThemeData.dark(),
      home: ScreenHome(),
    );
  }
}
