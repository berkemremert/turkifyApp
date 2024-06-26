import 'dart:math';

import 'package:flutter/material.dart';
import 'package:turkify_bem/mainTools/constLinks.dart';
import '../../../models/Category.dart';

import '../../../constants.dart';

class ProductTitleWithImage extends StatelessWidget {
  const ProductTitleWithImage({super.key, required this.book});

  final Book book;
  @override
  Widget build(BuildContext context) {
    Random random = Random();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            book.title,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: kDefaultPaddin),
          Row(
            children: <Widget>[
              book.image != aiImage ?
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "Read\n"),
                    book.price != 0 ?
                    TextSpan(
                      text: "${book.price}\n",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                    ) :
                    TextSpan(
                      text: random.nextInt(100).toString() + '\n',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: "times\n"),
                  ],
                ),
              ) : Container(width: 50,),
              SizedBox(width: kDefaultPaddin),
              Expanded(
                child: Hero(
                  tag: "${book.id}",
                  child: Image.network(
                    book.image,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              book.image == aiImage ?
              Container(width: 60,) :
                  Container(),
            ],
          )
        ],
      ),
    );
  }
}
