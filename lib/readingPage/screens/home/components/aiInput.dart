import 'package:flutter/material.dart';
import 'package:turkify_bem/geminiCodes.dart';
import 'package:turkify_bem/mainTools/APPColors.dart';
import 'package:turkify_bem/mainTools/constLinks.dart';

import '../../../models/Category.dart';
import '../../details/details_screen.dart';

class AiInput extends StatefulWidget {
  @override
  _AiInputState createState() => _AiInputState();
}

class _AiInputState extends State<AiInput> {
  final List<String> dropdownItems = ['A1', 'A2', 'B1', 'B2', 'C1'];
  String dropdownValue = 'A1';
  TextEditingController textFieldController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 12,
                        blurRadius: 12,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    'Enter your prompt',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                Container(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 0,
                    ),
                    child: TextField(
                      controller: textFieldController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Describe the story that you want to create by using AI',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                DropdownButton<String>(
                  value: dropdownValue,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    }
                  },
                  items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: isLoading ? null : () => _sendRequest(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: baseDeepColor,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                  child: isLoading
                      ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 3,
                    ),
                  )
                      : Text(
                    'Send',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendRequest() async {
    setState(() {
      isLoading = true;
    });

    String userInput = textFieldController.text;
    List<String?> output = await talkWithGemini2(userInput, dropdownValue);

    setState(() {
      isLoading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(
          book: Book(image: aiImage, title: output[1]!, description: output[0]!, price: 0, id: '0'),
        ),
      ),
    );
  }
}
