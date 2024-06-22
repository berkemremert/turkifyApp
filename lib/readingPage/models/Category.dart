import 'package:flutter/material.dart';



class Category {
  final String image, title;
  final int id;
  final Color color;
  final List<Book> books;

  Category(
      {required this.image,
      required this.title,
      required this.id,
      this.color = Colors.red,
      required this.books
      });
}

class Book {
  final String image, title, description, id;
  final int price;
  final Color color;

  Book(
      {required this.image,
        required this.title,
        required this.description,
        required this.price,
        required this.id,
        this.color = Colors.red,
      });
}
