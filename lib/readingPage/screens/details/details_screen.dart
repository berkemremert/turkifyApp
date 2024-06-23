import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../constants.dart';
import '../../models/Category.dart';
import 'components/description.dart';
import 'components/product_title_with_image.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      backgroundColor: Colors.black54,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.3),
                    padding: EdgeInsets.only(
                      top: size.height * 0.12,
                      left: kDefaultPaddin,
                      right: kDefaultPaddin,
                    ),
                    // height: 500,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Description(book: book),
                        const SizedBox(height: kDefaultPaddin / 2),
                      ],
                    ),
                  ),
                  ProductTitleWithImage(book: book)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
