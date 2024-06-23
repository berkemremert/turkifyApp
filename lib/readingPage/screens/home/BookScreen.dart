import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../constants.dart';
import '../../screens/details/details_screen.dart';

import '../../models/Category.dart';
import 'components/category_card.dart';
import 'components/BookCard.dart';


class BookScreen extends StatelessWidget {
  const BookScreen({super.key, required this.books});

  final List<Book> books;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
              child: GridView.builder(
                itemCount: books.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 3,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) => BookCard(
                  book: books[index],
                  press: () => Navigator.push(
                    context,
                    MaterialPageRoute(

                      builder: (context) => DetailsScreen(book: books[index]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
