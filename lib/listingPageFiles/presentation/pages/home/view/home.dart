// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:turkify_bem/listingPageFiles/presentation/pages/home/view/seeAllNear.dart';
import '../widgets/appbar.dart';
import '../widgets/button_group.dart';
import '../widgets/card_Horizontal_List.dart';
import '../widgets/card_vertical_list.dart';
import '../widgets/search_and_filter.dart';
import '../../../themes/colors.dart';
import '../../../themes/config.dart';

import '../widgets/title_bar.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);

    return Scaffold(
      backgroundColor: kColorScaffold,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SearchAndFilter(),
              kSizedBoxHeight_8,
              TitleBar__widget(title: 'Best tutors for you', ontap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SeeAllNear()),
                );
              }),
              CardHorizontalList__widget(),
              kSizedBoxHeight_8,
              TitleBar__widget(title: 'Friends profiles', ontap: () {}),
              CaerdVerticalList__widget(),
              kSizedBoxHeight_16,
            ],
          ),
        ),
      ),
    );
  }
}
