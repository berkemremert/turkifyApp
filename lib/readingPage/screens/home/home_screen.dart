import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../constants.dart';
import '../../screens/home/CategoryScreen.dart';

import '../../models/Category.dart';
import 'components/category_card.dart';

class ReadingPageDemo extends StatelessWidget {
  const ReadingPageDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/readingPage/icons/back.svg',
            color: Colors.blueGrey,
            // colorFilter: ColorFilter.mode(Colors.blueGrey, BlendMode.srcIn),
          ),
          onPressed: (){},
        ),
        actions: <Widget>[
          IconButton(
            icon: SvgPicture.asset(
              "assets/readingPage/icons/search.svg",
              color: kTextColor,
              // colorFilter: ColorFilter.mode(kTextColor, BlendMode.srcIn),
            ),
            onPressed: () {},
          ),

          const SizedBox(width: kDefaultPaddin / 2)
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
              child: GridView.builder(
                itemCount: category.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 3,
                  childAspectRatio: 1.5,
                ),
                itemBuilder: (context, index) => CategoryCard(
                  category: category[index],
                  press: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryScreen(
                          books: category[index].books),
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
