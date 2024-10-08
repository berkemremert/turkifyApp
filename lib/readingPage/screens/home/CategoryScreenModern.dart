import 'package:flutter/material.dart';
import 'package:turkify_bem/mainTools/APPColors.dart';
import 'package:turkify_bem/mainTools/firebaseMethods.dart';
import 'package:turkify_bem/readingPage/screens/home/components/aiInput.dart';

import '../../models/Category.dart';
import 'BookScreen.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<List<Book>> booksOfCategory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _bookInitializer();
  }

  _bookInitializer() async {
    List<List<Book>> tempBooks = [];
    for (int i = 0; i < 6; i++) {
      tempBooks.add(await getCategoryBookList(i));
    }
    setState(() {
      booksOfCategory = tempBooks;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(color: baseDeepColor,),
      )
          : Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: AspectRatio(
            aspectRatio: 2 / 3.5,
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 15.0,
              childAspectRatio: 1.0,
              children: List.generate(6, (index) {
                return CategoryButton(
                  index: index,
                  books: booksOfCategory.isNotEmpty ? booksOfCategory[index] : [],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final int index;
  final List<Book> books;
  final List<String> buttonTexts = [
    'Türk Kültürü',
    'Fıkralar',
    'Günlük Yaşam',
    'Spor',
    'Sinema',
    'Create with AI'
  ];

  CategoryButton({required this.index, required this.books});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        index != 5 ?
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookScreen(
              books: books,
            ),
          ),
        )
        :
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AiInput(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: getGradient(buttonTexts[index]),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  buttonTexts[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient getGradient(String text) {
    switch (text) {
      case 'Türk Kültürü':
        return LinearGradient(
          colors: [baseDeepColor, darkRed],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Fıkralar':
        return LinearGradient(
          colors: [Colors.yellow, Colors.amber],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Günlük Yaşam':
        return LinearGradient(
          colors: [Colors.green, Colors.teal],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Spor':
        return LinearGradient(
          colors: [Colors.blue, Colors.cyan],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Sinema':
        return LinearGradient(
          colors: [Colors.pink, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Create with AI':
        return LinearGradient(
          colors: [
            Colors.purple,
            Colors.blue,
            Colors.green,
            Colors.yellow,
            Colors.orange,
            Colors.red
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LinearGradient(
          colors: [Colors.blueAccent, Colors.lightBlueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }
}