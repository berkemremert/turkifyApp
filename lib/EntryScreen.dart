import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DashboardScreen.dart';
import 'loginMainScreenFiles/constants.dart';
import 'loginMainScreenFiles/login_screen.dart';
import 'loginMainScreenFiles/transition_route_observer.dart';
import 'mainTools/APPColors.dart';

class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});

  Future<bool> autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');

    if (email != null && password != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (userCredential.user?.emailVerified == false) {
          return false;
        }

        return true;
      } catch (e) {
        print('Auto login failed: $e');
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context){
    return FutureBuilder<bool>(
      future: autoLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Constants.appName,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Logging In...',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        } else {
          if (snapshot.hasData && snapshot.data!) {
            return MaterialApp(
              title: 'Entry',
              theme: ThemeData(
              ),
              navigatorObservers: [TransitionRouteObserver()],
              initialRoute: DashboardScreen.routeName,
              routes: {
                LoginScreen.routeName: (context) => LoginScreen(),
                DashboardScreen.routeName: (context) => const DashboardScreen(),
              },
            );
          } else {
            return MaterialApp(
              title: 'Entry',
              theme: ThemeData(
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
      },
    );
  }
}
