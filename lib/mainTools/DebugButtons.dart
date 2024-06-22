import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:turkify_bem/chatScreenFiles/FriendsListScreenChat.dart';
import 'package:turkify_bem/dictionaryPageFiles/WordMeaningPage.dart';
import 'package:turkify_bem/listingPageFiles/presentation/pages/home/view/TutorsPresentation.dart';
import 'package:turkify_bem/readingPage/screens/home/CategoryScreen.dart';
import 'package:turkify_bem/readingPage/screens/home/CategoryScreenModern.dart';
import 'package:turkify_bem/videoMeetingFiles/FriendsListScreenVideoMeeting.dart';
import 'package:turkify_bem/wordCardFiles/wordCards.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../geminiCodes.dart';

class ShowButtons extends StatefulWidget {
  @override
  _ShowButtonsState createState() => _ShowButtonsState();
}


class _ShowButtonsState extends State<ShowButtons> {
  bool _showAdditionalButtons = true;

  void _toggleButtons() {
    setState(() {
      _showAdditionalButtons = !_showAdditionalButtons;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 100,),
        ElevatedButton(
          onPressed: _toggleButtons,
          child: Text(_showAdditionalButtons ? 'Hide Buttons' : 'Show Buttons'),
        ),
        if (_showAdditionalButtons) ...[
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                      fontFamily: 'Roboto',
                    ),
                    home: CategoryScreen(),
                  ),
                ),
              );
            },
            child: Text('Easy Readings'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                      fontFamily: 'Roboto',
                    ),
                    home: DictionaryPage(),
                  ),
                ),
              );
            },
            child: Text('Word Center'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                      fontFamily: 'Roboto',
                    ),
                    home: WordCards(),
                  ),
                ),
              );
            },
            child: Text('Test Your Turkish'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                      fontFamily: 'Roboto',
                    ),
                    home: TutorsPresentation(),
                  ),
                ),
              );
            },
            child: Text('Matching Screen'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                      fontFamily: 'Roboto',
                    ),
                    home: FriendsListScreenChat(),
                  ),
                ),
              );
            },
            child: Text('Chat Screen'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                      fontFamily: 'Roboto',
                    ),
                    home: FriendsListScreenVideoMeeting(),
                  ),
                ),
              );
            },
            child: Text('Video Meeting'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                      fontFamily: 'Roboto',
                    ),
                    home: Container(),
                  ),
                ),
              );
            },
            child: Text('Welcoming Page'),
          ),
          ElevatedButton(
            onPressed: () {
              talkWithGemini();
            },
            child: const Text('Gemini Codes'),
          ),
        ],
      ],
    );
  }
}