import 'package:flutter/material.dart';
import 'presentation/pages/home/view/home.dart';

void listingScreenPage() {
  runApp(const listingScreen());
}

class listingScreen extends StatelessWidget {
  const listingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      home: const ScreenHome(),
    );
  }
}
