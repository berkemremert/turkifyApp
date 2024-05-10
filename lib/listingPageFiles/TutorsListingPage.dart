import 'package:flutter/material.dart';
import 'package:turkify_bem/listingPageFiles/presentation/pages/home/view/home.dart';
import 'package:turkify_bem/mainTools/imagedButton.dart';

import '../cardSlidingScreenFiles/cardSlider.dart';
import '../chatScreenFiles/FriendsListScreenChat.dart';

class TutorsListingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 70),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(0),
              child: Container(
                child: Center(
                  child: ImagedButton(imagePath: 'assets/tutorsListingPage/yourTutorsRedWhite.png',
                    buttonText: 'Your\nTutors',
                    ratio: 1,
                    shadowRadius: 7,
                    blurRadius: 10,
                    padding: 40.0,
                    fontWeight: FontWeight.w800,
                    imageOpacity: 0.45,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ScaffoldWidget(
                            title: "",
                            child: FriendsListScreenChat(),
                          ),
                        ),
                      );
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
                    ratio: 1,
                    shadowRadius: 7,
                    blurRadius: 10,
                    padding: 40.0,
                    fontWeight: FontWeight.w800,
                    imageOpacity: 0.45,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScreenHome(),
                        ),
                      );
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