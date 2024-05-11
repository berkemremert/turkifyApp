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

        await firestore.collection('users').doc(user!.uid).update({
          'fcmToken': {
            fcmToken: {
        'isLoggedIn': true,
        }},
        });

      } else {
        debugPrint('FCM token is null');
      }
    } catch (error) {
      debugPrint('Error initializing notifications: $error');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message: ${message.notification?.title}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
    });
  }

  Future<void> logOutFirebase(User user) async {
    try {
      final fcmToken = await _firebaseMessaging.getToken();

      if (fcmToken != null) {
        final firestore = FirebaseFirestore.instance;

        await firestore.collection('users').doc(user!.uid).update({
          'fcmToken': {
            fcmToken: {
              'isLoggedIn': false,
            }},
        });

      } else {
        debugPrint('FCM token is null');
      }
    } catch (error) {
      debugPrint('Error initializing notifications: $error');
    }
  }

// Future<void> sendNotification({
  //   required String receiverUid,
  //   required String title,
  //   required String body,
  // }) async {
  //   try {
  //     // Get FCM token of the receiver from Firestore
  //     final userDoc = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(receiverUid)
  //         .get();
  //
  //     if (userDoc.exists) {
  //       final fcmToken = userDoc.data()?['fcmToken'];
  //
  //       // Send notification using FCM
  //       await _firebaseMessaging.subscribeToTopic(receiverUid);
  //       await _firebaseMessaging.send(
  //         messaging.Message(
  //           notification: messaging.Notification(
  //             title: title,
  //             body: body,
  //           ),
  //           token: fcmToken,
  //         ),
  //       );
  //     } else {
  //       print('User document not found for $receiverUid');
  //     }
  //   } catch (error) {
  //     print('Error sending notification: $error');
  //   }
  // }

}