import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>> getAllInfo(String uid) async {
  DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

  if (userDoc.exists) {
    return (userDoc.data() as Map<String, dynamic>) ?? {}; // Return user data if available, or an empty map
  } else {
    return {};
  }
}