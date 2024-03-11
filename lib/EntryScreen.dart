import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turkify_bem/APPColors.dart';
import 'dashboard_screen.dart';
import 'loginMainScreenFiles/login_screen.dart';
import 'loginMainScreenFiles/transition_route_observer.dart';

class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Entry',
      theme: ThemeData(
        primaryColor: baseDeepColor,
        hintColor: baseLightColor,
        canvasColor: baseDeepColor,
        splashColor: baseDeepColor,
        dialogBackgroundColor: Colors.white,
        highlightColor: baseDeepColor,
        focusColor: baseDeepColor,
        primaryColorDark: baseDeepColor,
        secondaryHeaderColor: baseDeepColor,
        disabledColor: baseDeepColor,
        primaryColorLight: baseLightColor,
        unselectedWidgetColor: baseDeepColor,
        shadowColor: baseLightColor,
        buttonTheme: ButtonThemeData(
          buttonColor: baseDeepColor, // Sets the default button color
          textTheme: ButtonTextTheme.primary, // Sets the text color of buttons
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.white,
          contentTextStyle: TextStyle(
            color: Colors.black, // Change content text color
            fontSize: 16, // Change content font size
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Change dialog border radius
          ),
        ),
        textTheme: TextTheme(
          displaySmall: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 45.0,
            // fontWeight: FontWeight.w400,
          ),
          labelLarge: const TextStyle(
            // OpenSans is similar to NotoSans but the uppercases look a bit better IMO
            fontFamily: 'OpenSans',
          ),
          bodySmall: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color: baseDeepColor,
          ),
          displayLarge: const TextStyle(fontFamily: 'Quicksand'),
          displayMedium: const TextStyle(fontFamily: 'Quicksand'),
          headlineMedium: const TextStyle(fontFamily: 'Quicksand'),
          headlineSmall: const TextStyle(fontFamily: 'NotoSans'),
          titleLarge: const TextStyle(fontFamily: 'NotoSans'),
          titleMedium: const TextStyle(fontFamily: 'NotoSans'),
          bodyLarge: const TextStyle(fontFamily: 'NotoSans'),
          bodyMedium: const TextStyle(fontFamily: 'NotoSans'),
          titleSmall: const TextStyle(fontFamily: 'NotoSans'),
          labelSmall: const TextStyle(fontFamily: 'NotoSans'),
        ),
      ),
      navigatorObservers: [TransitionRouteObserver()],
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        DashboardScreen.routeName: (context) => const DashboardScreen(),
      },
    );
  }
}
