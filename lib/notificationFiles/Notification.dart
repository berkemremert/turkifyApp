import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationMethods {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<bool> checkNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;
    return status.isGranted;
  }

  Future<void> requestPermissions() async{
    if(await checkNotificationPermission()) {
      await _firebaseMessaging.requestPermission();
    }
  }

  Future<void> initNotification(User user) async {
    try {
      final fcmToken = await _firebaseMessaging.getToken();

      if (fcmToken != null) {
        final firestore = FirebaseFirestore.instance;
        final userDoc = await firestore.collection('users').doc(user!.uid).get();
        final fcmTokenExists = userDoc.exists && userDoc.data()!.containsKey('fcmToken');

        await firestore.collection('users').doc(user!.uid).update({
          'fcmToken': fcmToken,
        });

      } else {
        debugPrint('FCM token is null');
      }
    } catch (error) {
      debugPrint('Error initializing notifications: $error');
    }
  }


}