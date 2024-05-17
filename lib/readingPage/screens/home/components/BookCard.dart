import 'package:flutter/material.dart';
import '../../../models/Category.dart';

import '../../../constants.dart';

class BookCard extends StatelessWidget {
  const BookCard({super.key, required this.book, required this.press});

  final Book book;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(kDefaultPaddin),
              decoration: BoxDecoration(
                color: book.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Hero(
                tag: "${book.id}",
                child: Image.asset(book.image),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin / 4),
            child: Text(
              // books is out demo list
              book.title,
              style: TextStyle(color: kTextLightColor),
            ),
          ),
          Text(
            "\$${book.price}",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
