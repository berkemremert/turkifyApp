import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseMethods {
  static User? user;
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore db = FirebaseFirestore.instance;
  static StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? callStream;
  static bool isBeingCalled = false;

  FirebaseMethods() {
    user = FirebaseAuth.instance.currentUser;
    auth = FirebaseAuth.instance;
    db = FirebaseFirestore.instance;
  }

  Future<Map<String, dynamic>> getUserData() async {
    Map<String, dynamic> userData;

    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection(
        'users').doc(user?.uid).get();
    userData = (userDoc.data() as Map<String, dynamic>);

    return userData;
  }

  Future<Map<String, dynamic>> getUserDataWithID(String uid) async {
    Map<String, dynamic> userData;

    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection(
        'users').doc(uid).get();
    userData = (userDoc.data() as Map<String, dynamic>);

    return userData;
  }

  Future<Map<String, dynamic>?> getCallerData(String userId) async {
    Map<String, dynamic>? callerData;

    var callSnapshot = await db
        .collection('currentCalls')
        .where('calleeId', isEqualTo: userId)
        .get();

    if (callSnapshot.docs.isNotEmpty) {
      for (var doc in callSnapshot.docs) {
        var callerIdString = doc.data()['callerId'];
        callerData = await getUserDataWithID(callerIdString);
      }

      return callerData;
    }
  }

  Future<void> listenToCallField() async {
    callStream = FirebaseFirestore.instance
        .collection('currentCalls')
        .where('calleeId', isEqualTo: user!.uid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        isBeingCalled = true;
      } else {
        isBeingCalled = false;
      }
    });
  }

  Future<void> checkIfBeingCalled() async {
    bool beingCalled = (await getCallerData(user!.uid) != null);
    isBeingCalled = beingCalled;
  }

  Future<void> updateInformation(var field, String information, String uid) async {
    final firestore = FirebaseFirestore.instance;

    await firestore.collection('users').doc(uid).update({
      field : double.infinity,
    });
  }

}