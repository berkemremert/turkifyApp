import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:turkify_bem/mainTools/APPColors.dart';
import '../mainTools/firebaseMethods.dart';

class WordCards extends StatefulWidget {
  @override
  _WordCardsState createState() => _WordCardsState();
}

class _WordCardsState extends State<WordCards> {
  String selectedOption = '';
  bool isCorrect = false;
  int currentQuestionIndex = 0;
  int correctAnswersCount = 0;
  bool showResults = false;
  bool showQuestionScreen = true;
  bool isLoading = false;
  int totalQuestions = 0;
  List<Map<String, dynamic>> questions = [];
  User? user;

  @override
  void initState() {
    super.initState();
    initializeUser();
  }

  Future<void> initializeUser() async {
    user = FirebaseAuth.instance.currentUser;
    setState(() {});
  }

  void checkAnswer(String option) {
    setState(() {
      selectedOption = option;
      isCorrect = option == questions[currentQuestionIndex]['asked_word_in_english'];
      if (isCorrect) correctAnswersCount++;
      questions[currentQuestionIndex]['answered_correctly'] = isCorrect;
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex < totalQuestions - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedOption = '';
        isCorrect = false;
      });
    } else {
      setState(() {
        showResults = true;
      });
      sendQuizResultsToFirebase();
    }
  }

  void restartQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      selectedOption = '';
      isCorrect = false;
      correctAnswersCount = 0;
      showResults = false;
      showQuestionScreen = true;
    });
  }

  Future<void> startQuiz(int numQuestions) async {
    setState(() {
      isLoading = true;
    });

    List<String> usedQuestions = [];
    questions = [];
    for (int i = 0; i < numQuestions; i++) {
      Map<String, dynamic> questionSet = await createQuestion('A1', usedQuestions);
      questionSet['answered_correctly'] = false;
      questions.add(questionSet);
    }

    setState(() {
      totalQuestions = numQuestions;
      showQuestionScreen = false;
      currentQuestionIndex = 0;
      correctAnswersCount = 0;
      isLoading = false;
    });
  }

  Future<void> sendQuizResultsToFirebase() async {
    if (user == null) {
      return;
    }

    List<Map<String, dynamic>> results = questions.map((question) {
      return {
        'word_id': question['used_id'],
        'answered_correctly': question['answered_correctly']
      };
    }).toList();

    String quizId = DateTime.now().toIso8601String();
    await FirebaseFirestore.instance
        .collection('quizResults')
        .doc(user!.uid)
        .collection('quizzes')
        .doc(quizId)
        .set({
      'results': results,
      'user_info': {
        'user_id': user!.uid,
        'user_email': user!.email,
      },
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = (currentQuestionIndex + 1) / totalQuestions;

    return Scaffold(
      appBar: AppBar(
        title: Text('Test Your Turkish'),
        automaticallyImplyLeading: !showResults,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: showQuestionScreen
            ? isLoading
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: baseDeepColor),
              SizedBox(height: 16),
              Text('Your quiz is being created...'),
            ],
          ),
        )
            : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'How many questions do you want to answer?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildQuizButton(5, Colors.red[100]!),
                  _buildQuizButton(10, Colors.red[200]!),
                  _buildQuizButton(15, Colors.red[300]!),
                  _buildQuizButton(20, Colors.red[400]!),
                ],
              ),
            ],
          ),
        )
            : showResults
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Quiz Completed!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'You got $correctAnswersCount out of $totalQuestions correct!',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: restartQuiz,
                child: Text(
                  'Restart Quiz',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: baseDeepColor,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  elevation: 5,
                  shadowColor: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Exit',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: baseDeepColor,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  elevation: 5,
                  shadowColor: Colors.black,
                ),
              ),
            ],
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              color: baseDeepColor,
            ),
            SizedBox(height: 30),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Select the correct image for ',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  TextSpan(
                    text: questions[currentQuestionIndex]['asked_word_in_turkish'],
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
                  children: List.generate(4, (index) {
                    var option = questions[currentQuestionIndex]['options'][index];
                    return OptionWidget(
                      imageUrl: option['picture'],
                      label: option['english_word'],
                      selected: selectedOption == option['english_word'],
                      correct: isCorrect,
                      onTap: selectedOption.isEmpty ? () => checkAnswer(option['english_word']) : null,
                    );
                  }),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: selectedOption.isNotEmpty ? nextQuestion : null,
                child: Text(
                  'CONTINUE',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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

  Widget _buildQuizButton(int numQuestions, Color color) {
    return ElevatedButton(
      onPressed: () => startQuiz(numQuestions),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: '$numQuestions\n',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: 'Questions',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 5,
        shadowColor: Colors.black,
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
              offset: Offset(0, 3),
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
                      color: baseDeepColor,
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

Future<List<String>> getQuestionsInLevel(String level) async {
  List<String> allSuitableId = [];
  await FirebaseFirestore.instance.collection('quizWords').where('level', isEqualTo: level).get().then((queries) {
    for (var q in queries.docs) {
      allSuitableId.add(q.id);
    }
  });
  return allSuitableId;
}

Future<Map<String, dynamic>> getWordForQuiz(String id) async {
  DocumentSnapshot wordDoc = await FirebaseFirestore.instance.collection('quizWords').doc(id).get();
  return wordDoc.data() as Map<String, dynamic>;
}

Future<Map<String, dynamic>> createQuestion(String level, List<String> usedQuestions) async {
  int totalOptionCount = 4;
  List<String> allIds = await getQuestionsInLevel(level);
  List<String> canBeAsked = List.from(allIds);

  canBeAsked.removeWhere((id) => usedQuestions.contains(id));

  Random randGen = Random();
  int index = randGen.nextInt(canBeAsked.length);
  Map<String, dynamic> pickedQuestion = await getWordForQuiz(canBeAsked[index]);

  allIds.remove(canBeAsked[index]);
  List<Map<String, dynamic>> pickedOptions = [];

  for (int i = 0; i < totalOptionCount - 1; i++) {
    int ind = randGen.nextInt(allIds.length);
    Map<String, dynamic> pickedTemp = await getWordForQuiz(allIds[ind]);
    pickedOptions.add(pickedTemp);
    allIds.removeAt(ind);
  }

  int correctPosition = randGen.nextInt(totalOptionCount);
  pickedOptions.insert(correctPosition, pickedQuestion);

  usedQuestions.add(canBeAsked[index]);

  Map<String, dynamic> question = {
    'asked_word_in_turkish': pickedQuestion['turkish_word'],
    'asked_word_in_english': pickedQuestion['english_word'],
    'options': pickedOptions,
    'correct_position': correctPosition,
    'used_id': canBeAsked[index],
    'new_used_list': usedQuestions,
  };

  return question;
}