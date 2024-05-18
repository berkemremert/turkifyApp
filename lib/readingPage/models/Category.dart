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
      required this.color,
      required this.books
      });
}

class Book {
  final String image, title, description;
  final int price, id;
  final Color color;

  Book(
      {required this.image,
        required this.title,
        required this.description,
        required this.price,
        required this.id,
        required this.color,
      });
}

List<Category> category = [
  Category(
      id: 1,
      title: "Fear",
      image: "assets/readingPage/images/Fear_category.png",
      color: Color(0xFF3D82AE),
      books: [Book(
                id: 1,
                title: "Gulyabani",
                price: 234,
                description: dummyText,
                image: "assets/readingPage/images/book.png",
                color: Color(0xFFFB7883)
              ),
              Book(
                  id: 2,
                  title: "Gulyabani2",
                  price: 300,
                  description: dummyText,
                  image: "assets/readingPage/images/book.png",
                  color: Color(0xFF81FF00)
              ),
              Book(
                  id: 3,
                  title: "Gulyabani3",
                  price: 350,
                  description: dummyText,
                  image: "assets/readingPage/images/book.png",
                  color: Color(0xFFF00883)
              ),],
  ),
  Category(
      id: 2,
      title: "Türk Tarihi",
      image: "assets/readingPage/images/turkish_history.jpg",
      color: Color(0xFF0094FF),
      books: [Book(
                id: 1,
                title: "Tarih Kitabı",
                price: 234,
                description: dummyText,
                image: "assets/readingPage/images/book.png",
                color: Color(0xFF101BD4)
        ),],
  ),

  Category(
      id: 3,
      title: "Hang Top",
      image: "assets/readingPage/images/category.jpg",
      color: Color(0xFF989493),
      books: [Book(
                id: 1,
                title: "Gulyabani",
                price: 234,
                description: dummyText,
                image: "assets/readingPage/images/book.png",
                color: Color(0xFFFB7883)
        ),],
  ),
  Category(
      id: 4,
      title: "Old Fashion",
      image: "assets/readingPage/images/category.jpg",
      color: Color(0xFFE6B398),
      books: [Book(
                id: 1,
                title: "Gulyabani",
                price: 234,
                description: dummyText,
                image: "assets/readingPage/images/book.png",
                color: Color(0xFFFB7883)
        ),],
  ),
  Category(
      id: 5,
      title: "Office Code",
      image: "assets/readingPage/images/category.jpg",
      color: Color(0xFFFB7883),
      books: [Book(
                id: 1,
                title: "Gulyabani",
                price: 234,
                description: dummyText,
                image: "assets/readingPage/images/book.png",
                color: Color(0xFFFB7883)
              ),],
  ),
  Category(
    id: 6,
    title: "Kategori1",
    image: "assets/readingPage/images/category.jpg",
    color: Color(0xFFAEAEAE),
    books: [Book(
              id: 1,
              title: "Gulyabani",
              price: 234,
              description: dummyText,
              image: "assets/readingPage/images/book.png",
              color: Color(0xFFFB7883)
            ),],
  ),
  Category(
    id: 6,
    title: "Kategori2",
    image: "assets/readingPage/images/category.jpg",
    color: Color(0xFFAEAEAE),
    books: [Book(
        id: 1,
        title: "Gulyabani",
        price: 234,
        description: dummyText,
        image: "assets/readingPage/images/book.png",
        color: Color(0xFFFB7883)
    ),],
  ),
  Category(
    id: 6,
    title: "Kategori3",
    image: "assets/readingPage/images/category.jpg",
    color: Color(0xFFAEAEAE),
    books: [Book(
        id: 1,
        title: "Gulyabani",
        price: 234,
        description: dummyText,
        image: "assets/readingPage/images/book.png",
        color: Color(0xFFFB7883)
    ),],
  ),
  Category(
    id: 6,
    title: "Kategori4",
    image: "assets/readingPage/images/category.jpg",
    color: Color(0xFFAEAEAE),
    books: [Book(
        id: 1,
        title: "Gulyabani",
        price: 234,
        description: dummyText,
        image: "assets/readingPage/images/book.png",
        color: Color(0xFFFB7883)
    ),],
  ),
  Category(
    id: 6,
    title: "Kategori5",
    image: "assets/readingPage/images/category.jpg",
    color: Color(0xFFAEAEAE),
    books: [Book(
        id: 1,
        title: "Gulyabani",
        price: 234,
        description: dummyText,
        image: "assets/readingPage/images/book.png",
        color: Color(0xFFFB7883)
    ),],
  ),
  Category(
    id: 6,
    title: "Kategori6",
    image: "assets/readingPage/images/category.jpg",
    color: Color(0xFFAEAEAE),
    books: [Book(
        id: 1,
        title: "Gulyabani",
        price: 234,
        description: dummyText,
        image: "assets/readingPage/images/book.png",
        color: Color(0xFFFB7883)
    ),],
  ),
  Category(
    id: 6,
    title: "Kategori7",
    image: "assets/readingPage/images/category.jpg",
    color: Color(0xFFAEAEAE),
    books: [Book(
        id: 1,
        title: "Gulyabani",
        price: 234,
        description: dummyText,
        image: "assets/readingPage/images/book.png",
        color: Color(0xFFFB7883)
    ),],
  ),
  Category(
    id: 6,
    title: "Kategori8",
    image: "assets/readingPage/images/category.jpg",
    color: Color(0xFFAEAEAE),
    books: [Book(
        id: 1,
        title: "Gulyabani",
        price: 234,
        description: dummyText,
        image: "assets/readingPage/images/book.png",
        color: Color(0xFFFB7883)
    ),],
  ),
  Category(
    id: 6,
    title: "Kategor9i",
    image: "assets/readingPage/images/category.jpg",
    color: Color(0xFFAEAEAE),
    books: [Book(
        id: 1,
        title: "Gulyabani",
        price: 234,
        description: dummyText,
        image: "assets/readingPage/images/book.png",
        color: Color(0xFFFB7883)
    ),],
  ),
  Category(
    id: 6,
    title: "Kategori10",
    image: "assets/readingPage/images/category.jpg",
    color: Color(0xFFAEAEAE),
    books: [Book(
        id: 1,
        title: "Gulyabani",
        price: 234,
        description: dummyText,
        image: "assets/readingPage/images/book.png",
        color: Color(0xFFFB7883)
    ),],
  ),
  Category(
    id: 6,
    title: "Kategori11",
    image: "assets/readingPage/images/category.jpg",
    color: Color(0xFFAEAEAE),
    books: [Book(
        id: 1,
        title: "Gulyabani",
        price: 234,
        description: dummyText,
        image: "assets/readingPage/images/book.png",
        color: Color(0xFFFB7883)
    ),],
  ),
  Category(
    id: 6,
    title: "Kategori12",
    image: "assets/readingPage/images/category.jpg",
    color: Color(0xFFAEAEAE),
    books: [Book(
        id: 1,
        title: "Gulyabani",
        price: 234,
        description: dummyText,
        image: "assets/readingPage/images/book.png",
        color: Color(0xFFFB7883)
    ),],
  ),
  Category(
    id: 6,
    title: "Kategori13",
    image: "assets/readingPage/images/category.jpg",
    color: Color(0xFFAEAEAE),
    books: [Book(
        id: 1,
        title: "Gulyabani",
        price: 234,
        description: dummyText,
        image: "assets/readingPage/images/book.png",
        color: Color(0xFFFB7883)
    ),],
  ),
  Category(
    id: 6,
    title: "Kategori14",
    image: "assets/readingPage/images/category.jpg",
    color: Color(0xFFAEAEAE),
    books: [Book(
        id: 1,
        title: "Gulyabani",
        price: 234,
        description: dummyText,
        image: "assets/readingPage/images/book.png",
        color: Color(0xFFFB7883)
    ),],
  ),
  Category(
    id: 6,
    title: "Kategori15",
    image: "assets/readingPage/images/category.jpg",
    color: Color(0xFFAEAEAE),
    books: [Book(
        id: 1,
        title: "Gulyabani",
        price: 234,
        description: dummyText,
        image: "assets/readingPage/images/book.png",
        color: Color(0xFFFB7883)
    ),],
  ),
  Category(
    id: 6,
    title: "Kategori16",
    image: "assets/readingPage/images/category.jpg",
    color: Color(0xFFAEAEAE),
    books: [Book(
        id: 1,
        title: "Gulyabani",
        price: 234,
        description: dummyText,
        image: "assets/readingPage/images/book.png",
        color: Color(0xFFFB7883)
    ),],
  ),

];

var dummyText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi blandit leo ac auctor volutpat. Proin consequat risus euismod sem ultrices bibendum. Curabitur commodo, tellus in dapibus accumsan, augue purus aliquet tortor, vitae blandit quam risus nec purus. Nulla commodo, orci quis efficitur vulputate, nulla tellus molestie augue, nec rhoncus velit leo ac diam. Etiam at nunc ac nisi viverra varius sed vel velit. Nulla lectus felis, molestie sed aliquet id, commodo ac turpis. Morbi sit amet purus eu purus fermentum commodo. Nulla in ex eget justo sodales tincidunt a a purus. Donec vitae tellus risus. Vestibulum eu consequat neque, a luctus tellus. Phasellus sed lectus justo. Vestibulum sit amet gravida lacus. Fusce vitae molestie orci. Nam aliquet consequat arcu sit amet sagittis. Praesent gravida, sapien sit amet congue rutrum, neque nisl semper mi, ac elementum risus orci vitae risus.";