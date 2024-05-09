import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turkify_bem/mainTools/APPColors.dart';

import 'MyElevatedButton.dart';

class LanguageLevel extends StatefulWidget {
  final Map<String, dynamic> userData;
  const LanguageLevel({required this.userData, super.key});

  @override
  State<LanguageLevel> createState() => _LanguageLevelState();
}

class _LanguageLevelState extends State<LanguageLevel> {
  List<dynamic> langs = [];
  bool isTutor = false;
  @override
  void initState() {
    super.initState();
    isTutor = widget.userData['isTutor'];
    langs = (isTutor)
        ? widget.userData['tutorMap']['teachingLevel']
        : widget.userData['studentMap']['teachingLevel'];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor(),
      body: Center(
        child: Column(
          children: (isTutor) ? _tutorList() : _studentList(),
        ),
      ),
    );
  }

  _tutorList() {
    print(langs);

    return [
      const SizedBox(height: 30),
      Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: white,
          border: Border.all(
              color: textColor(),
              width: 2
          ),
        ),
        child: Center(
          child: Text(
            isTutor ? "Choose your speciality level" : "Choose Your Level",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      const SizedBox(height: 50),
      const Text(
        "Beginner",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      MyElevatedButton(
        startColor: langs.contains("A1") ? blueAccent : Colors.red,
        text: "A1",
        endColor: langs.contains("A1") ? Colors.blueGrey : Colors.red.withOpacity(0.75),
        onPressed: () {
          _buttonPressedTutor("A1");
        },
      ),
      const SizedBox(height: 20),
      MyElevatedButton(
        text: "A2",
        startColor: langs.contains("A2") ? blueAccent : Colors.red,
        endColor: langs.contains("A2") ? Colors.blueGrey : Colors.red.withOpacity(0.75),
        onPressed: () {
          _buttonPressedTutor("A2");
        },
      ),

      const SizedBox(height: 40),
      const Text(
        "Intermediate",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      MyElevatedButton(
        text: "B1",
        startColor: langs.contains("B1") ? blueAccent : Colors.red,
        endColor: langs.contains("B1") ? Colors.blueGrey : Colors.red.withOpacity(0.75),
        onPressed: () {
          _buttonPressedTutor("B1");
        },
      ),
      const SizedBox(height: 20),
      MyElevatedButton(
        text: "B2",
        startColor: langs.contains("B2") ? blueAccent : Colors.red,
        endColor: langs.contains("B2") ? Colors.blueGrey : Colors.red.withOpacity(0.75),
        onPressed: () {
          _buttonPressedTutor("B2");
        },
      ),
      const SizedBox(height: 40),
      const Text(
        "Expert",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      MyElevatedButton(
        text: "C1",
        startColor: langs.contains("C1") ? blueAccent : Colors.red,
        endColor: langs.contains("C1") ? Colors.blueGrey : Colors.red.withOpacity(0.75),
        onPressed: () {
          _buttonPressedTutor("C1");
        },
      ),
      const SizedBox(height: 20),
      MyElevatedButton(
        text: "C2",
        startColor: langs.contains("C2") ? blueAccent : Colors.red,
        endColor: langs.contains("C2") ? Colors.blueGrey : Colors.red.withOpacity(0.75),
        onPressed: () {
          _buttonPressedTutor("C2");
        },
      ),
    ];
  }

  _studentList() {
    return [
      const SizedBox(height: 30),
      Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: white,
          border: Border.all(
              color: textColor(),
              width: 2
          ),
        ),
        child: const Center(
          child: Text(
            "Choose Your Level",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      const SizedBox(height: 50),
      const Text(
        "Beginner",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      MyElevatedButton(
        text: "A1",
        endColor: Colors.red.withOpacity(0.75),
        onPressed: () {},
      ),
      const SizedBox(height: 20),
      MyElevatedButton(
        text: "A2",
        endColor: Colors.red.withOpacity(0.75),
        onPressed: () {},
      ),

      const SizedBox(height: 40),
      const Text(
        "Intermediate",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      MyElevatedButton(
        text: "B1",
        endColor: Colors.red.withOpacity(0.75),
        onPressed: () {},
      ),
      const SizedBox(height: 20),
      MyElevatedButton(
        text: "B2",
        endColor: Colors.red.withOpacity(0.75),
        onPressed: () {},
      ),
      const SizedBox(height: 40),
      const Text(
        "Expert",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      MyElevatedButton(
        text: "C1",
        endColor: Colors.red.withOpacity(0.75),
        onPressed: () {},
      ),
      const SizedBox(height: 20),
      MyElevatedButton(
        text: "C2",
        endColor: Colors.red.withOpacity(0.75),
        onPressed: () {},
      ),
    ];
  }

  Future<void> _buttonPressedTutor(String text) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference userRef = firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
    if (langs.contains(text)) {
      setState(() {
        langs.remove(text);
      });
    } else {
      setState(() {
        langs.add(text);
      });
    }
    Map<String, dynamic> tutorMap = widget.userData['tutorMap'];
    tutorMap['teachingLevel'] = langs;
    await userRef.update({'tutorMap': tutorMap});

    print('Teaching level updated successfully.');
  }

}
