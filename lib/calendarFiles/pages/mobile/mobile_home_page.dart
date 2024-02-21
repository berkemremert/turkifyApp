import 'package:flutter/material.dart';

import '../day_view_page.dart';
import '../month_view_page.dart';
import '../week_view_page.dart';

class MobileHomePage extends StatefulWidget {
  @override
  _MobileHomePageState createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    MonthViewPageDemo(),
    WeekViewDemo(),
    DayViewPageDemo(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor:
            Colors.deepPurple, // Changing primary color to deep purple
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Calendar",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor:
              Colors.deepPurple, // Changing app bar color to deep purple
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_view_month),
              label: 'Month',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_view_week),
              label: 'Week',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Day',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.deepPurple,
          // Changing selected item color to deep purple
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
