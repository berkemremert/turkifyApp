import 'package:flutter/material.dart';
import 'package:turkify_bem/APPColors.dart';

import '../../../listingPageFiles/gen/assets.gen.dart';
import '../../../listingPageFiles/presentation/themes/colors.dart';
import '../../../listingPageFiles/presentation/themes/config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../listingPageFiles/presentation/themes/config_files/screen_size_config.dart';

class dictionaryBar extends StatelessWidget {
  const dictionaryBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Row(
        children: <Widget>[
          Container(

            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 16.0),
            decoration: BoxDecoration(
              color: kColorSecondary,
              borderRadius: BorderRadius.circular(12),
            ),
            width: MediaQuery.of(context).size.width*77/100,
            height: 48,
            child: Row(
              children: <Widget>[
                kSizedBoxWidth_8,
                const Expanded(
                  child: TextField(
                    style: kSearchTextStyle,
                    cursorColor: kColorPrimary,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Kelime Ara',
                      hintStyle: kSearchTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(12),
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: baseDeepColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(FontAwesomeIcons.search, color: Colors.white,),
            ),
          ),
        ],
      ),
    );
  }
}

const kSearchTextStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  letterSpacing: 0.5,
);
