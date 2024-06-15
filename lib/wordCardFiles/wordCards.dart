import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:turkify_bem/mainTools/APPColors.dart';

class WordCards extends StatefulWidget {
  @override
  _WordCardsState createState() => _WordCardsState();
}

class _WordCardsState extends State<WordCards> {
  String selectedOption = '';
  bool isCorrect = false;

  void checkAnswer(String option) {
    setState(() {
      selectedOption = option;
      isCorrect = option == 'bread'; // Correct answer is 'bread'
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Duolingo Style Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Select the correct image for ',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  TextSpan(
                    text: 'ekmek',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: baseDeepColor),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Center(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  shrinkWrap: true,
                  children: [
                    OptionWidget(
                      imageUrl: 'https://www.allrecipes.com/thmb/3Bhpg3W6sjCn0VTQ_yXLUyHr-3k=/0x512/filters:no_upscale():max_bytes(150000):strip_icc()/6788-amish-white-bread-DDMFS-4x3-6faa1e552bdb4f6eabdd7791e59b3c84.jpg',
                      label: 'bread',
                      selected: selectedOption == 'bread',
                      correct: isCorrect,
                      onTap: selectedOption.isEmpty ? () => checkAnswer('bread') : null,
                    ),
                    OptionWidget(
                      imageUrl: 'https://via.placeholder.com/80',
                      label: 'water',
                      selected: selectedOption == 'water',
                      correct: isCorrect,
                      onTap: selectedOption.isEmpty ? () => checkAnswer('water') : null,
                    ),
                    OptionWidget(
                      imageUrl: 'https://media.istockphoto.com/id/1369508766/tr/foto%C4%9Fraf/beautiful-successful-latin-woman-smiling.jpg?s=612x612&w=0&k=20&c=i49d7dflU-FTNE8QgmZcxvaKBdjH-gardI1RWhTyqbc=',
                      label: 'woman',
                      selected: selectedOption == 'woman',
                      correct: isCorrect,
                      onTap: selectedOption.isEmpty ? () => checkAnswer('woman') : null,
                    ),
                    OptionWidget(
                      imageUrl: 'https://via.placeholder.com/80',
                      label: 'apple',
                      selected: selectedOption == 'apple',
                      correct: isCorrect,
                      onTap: selectedOption.isEmpty ? () => checkAnswer('apple') : null,
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: selectedOption.isNotEmpty ? () {} : null,
                child: Text(
                  'CONTINUE',
                  style: TextStyle(color: selectedOption.isNotEmpty ? Colors.white : Colors.black54,
                      fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: baseDeepColor,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  elevation: 5,
                  shadowColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OptionWidget extends StatelessWidget {
  final String imageUrl;
  final String label;
  final bool selected;
  final bool correct;
  final VoidCallback? onTap;

  OptionWidget({
    required this.imageUrl,
    required this.label,
    required this.selected,
    required this.correct,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: selected
              ? (correct ? Colors.green.withOpacity(0.5) : Colors.red.withOpacity(0.5))
              : Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (context, url) => Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: Colors.red,
                      strokeWidth: 2.0,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
