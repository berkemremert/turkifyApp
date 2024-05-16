import 'package:flutter/material.dart';
import 'package:shop_app/models/Category.dart';

import '../../../constants.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category, required this.press});

  final Category category;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(category.image),
                      fit: BoxFit.cover,
                    ),
                    color: category.color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Text(
                  category.title,
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 24
                  ),
                )
              ],
            ),

          ),


        ],
      ),
    );
  }
}
