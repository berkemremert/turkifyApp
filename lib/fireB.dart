import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login/flutter_login.dart';

class fireB{
  Future<String?> signupUser(SignupData data) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data.name ?? "",
        password: data.password ?? "",
      );

      await userCredential.user?.sendEmailVerification();

      await FirebaseFirestore.instance.collection('users').doc(data.name).set({
        'username': data.additionalSignupData?['Username'],
        'name': data.additionalSignupData?['Name'],
        'surname': data.additionalSignupData?['Surname'],
        'phoneNumber': data.additionalSignupData?['phone_number'],
        'friends' : [],
      });

      return "Success";
    } catch (e) {
      return e.toString(); // ERROR MESSAGE
    }
  }
}