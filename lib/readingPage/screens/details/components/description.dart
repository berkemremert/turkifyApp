import 'package:flutter/material.dart';
import '../../../models/Category.dart';

import '../../../constants.dart';

class Description extends StatelessWidget {
  const Description({super.key, required this.book});

  final Book book;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
      child: Text(
        book.description,
        style: TextStyle(height: 1.5),
      ),
    );
  }
}
