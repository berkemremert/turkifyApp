import 'package:flutter/material.dart';
import 'package:turkify_bem/mainTools/APPColors.dart';

import 'MyElevatedButton.dart';

class LanguageLevel extends StatefulWidget {
  const LanguageLevel({super.key});

  @override
  State<LanguageLevel> createState() => _LanguageLevelState();
}

class _LanguageLevelState extends State<LanguageLevel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor(),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 100),
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
          ],
        ),
      ),
    );
  }
}
