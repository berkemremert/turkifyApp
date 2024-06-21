import 'package:flutter/material.dart';
import 'package:turkify_bem/mainTools/firebaseMethods.dart';

import '../../models/Category.dart';
import 'BookScreen.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Book> booksOfCategory = [];

  @override
  void initState() {
    super.initState();
    _bookInitializer();
  }

  _bookInitializer() async{
    booksOfCategory = await getCategoryBookList(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Padding(
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
                  return CategoryButton(index: index);
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final int index;
  final List<String> buttonTexts = [
    'Türk Kültürü',
    'Fıkralar',
    'Günlük Yaşam',
    'Spor',
    'Sinema',
    'Yapay Zekayla Oluştur'
  ];

  CategoryButton({required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookScreen(
              books: getCategoryBookList(index),
            ),
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
          colors: [Colors.red, Colors.deepOrange],
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
      case 'Yapay Zekayla Oluştur':
        return LinearGradient(
          colors: [Colors.purple, Colors.blue, Colors.green, Colors.yellow, Colors.orange, Colors.red],
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