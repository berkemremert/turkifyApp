import 'package:flutter/material.dart';
import 'package:turkify_bem/listingPageFiles/presentation/pages/home/view/TutorsPresentation.dart';
import 'package:turkify_bem/mainTools/imagedButton.dart';

import '../cardSlidingScreenFiles/cardSlider.dart';
import '../chatScreenFiles/FriendsListScreenChat.dart';

class WelcomingInformationPage extends StatelessWidget {
  const WelcomingInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 50),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(0),
              child: Container(
                child: Center(
                  child: ImagedButton(imagePath: 'assets/tutorsListingPage/yourTutorsRedWhite.png',
                    buttonText: 'Tell\nUs About\nYourself',
                    ratio: 1.55,
                    shadowRadius: 7,
                    blurRadius: 10,
                    padding: 40.0,
                    fontWeight: FontWeight.w800,
                    imageOpacity: 0.45,
                    fontSize: 30,
                    onTap: () {
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(0),
              child: Container(
                child: Center(
                  child: ImagedButton(imagePath: 'assets/tutorsListingPage/newTutorsRed.png',
                    buttonText: 'Find\nTutors',
                    ratio: 1.55,
                    shadowRadius: 7,
                    blurRadius: 10,
                    padding: 40.0,
                    fontWeight: FontWeight.w800,
                    imageOpacity: 0.45,
                    fontSize: 30,
                    onTap: () {

                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(0),
              child: Container(
                child: Center(
                  child: ImagedButton(imagePath: 'assets/tutorsListingPage/newTutorsRed.png',
                    buttonText: 'Find\nTutors',
                    ratio: 1.55,
                    shadowRadius: 7,
                    blurRadius: 10,
                    padding: 40.0,
                    fontWeight: FontWeight.w800,
                    imageOpacity: 0.45,
                    fontSize: 30,
                    onTap: () {

                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}