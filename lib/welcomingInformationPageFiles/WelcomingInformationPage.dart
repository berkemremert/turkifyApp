import 'package:flutter/material.dart';
import 'package:turkify_bem/mainTools/imagedButton.dart';


class WelcomingInformationPage extends StatefulWidget {
  const WelcomingInformationPage({Key? key}) : super(key: key);

  @override
  _WelcomingInformationPageState createState() => _WelcomingInformationPageState();
}

class _WelcomingInformationPageState extends State<WelcomingInformationPage> {
  bool isFlipped = false;

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
              child: Stack(
                children: [
                  Center(
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      child: isFlipped
                          ? Container(
                        key: UniqueKey(),
                        color: Colors.blue,
                        alignment: Alignment.center,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter your text here',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      )
                          : ImagedButton(
                        key: UniqueKey(),
                        imagePath: 'assets/tutorsListingPage/yourTutorsRedWhite.png',
                        buttonText: 'Tell\nUs About\nYourself',
                        ratio: 1.55,
                        shadowRadius: 7,
                        blurRadius: 10,
                        padding: 40.0,
                        fontWeight: FontWeight.w800,
                        imageOpacity: 0.45,
                        fontSize: 30,
                        onTap: () {
                          setState(() {
                            isFlipped = !isFlipped;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(0),
              child: Container(
                child: Center(
                  child: ImagedButton(
                    imagePath: 'assets/tutorsListingPage/newTutorsRed.png',
                    buttonText: 'Tutor Or\nStudent',
                    ratio: 1.55,
                    shadowRadius: 7,
                    blurRadius: 10,
                    padding: 40.0,
                    fontWeight: FontWeight.w800,
                    imageOpacity: 0.45,
                    fontSize: 30,
                    onTap: () {},
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
                  child: ImagedButton(
                    imagePath: 'assets/tutorsListingPage/newTutorsRed.png',
                    buttonText: 'Turkish\nProficiency\nLevel',
                    ratio: 1.55,
                    shadowRadius: 7,
                    blurRadius: 10,
                    padding: 40.0,
                    fontWeight: FontWeight.w800,
                    imageOpacity: 0.45,
                    fontSize: 30,
                    onTap: () {},
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