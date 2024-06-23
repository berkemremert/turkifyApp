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
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Hero(
                tag: "${book.id}",
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/loading-gif.gif',
                  image: book.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin / 4),
            child: Text(
              book.title,
              style: TextStyle(color: kTextLightColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
