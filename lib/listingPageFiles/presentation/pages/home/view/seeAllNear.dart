import 'package:flutter/material.dart';
import '../../../../../personList.dart';
import '../../../../../referencePageFiles/referencePage.dart';
import '../widgets/appbar.dart';
import '../widgets/button_group.dart';
import '../widgets/card_Horizontal_List.dart';
import '../widgets/card_vertical_list.dart';
import '../widgets/search_and_filter.dart';
import '../../../themes/colors.dart';
import '../../../themes/config.dart';

import '../widgets/cardVerticalSmart.dart';
import '../widgets/choosableButtons.dart';
import '../widgets/title_bar.dart';

class SeeAllNear extends StatefulWidget {
  final int filter;

  SeeAllNear({Key? key, this.filter = 0}) : super(key: key);

  @override
  _SeeAllNearState createState() => _SeeAllNearState();
}

class _SeeAllNearState extends State<SeeAllNear> {
  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);

    return Scaffold(
      backgroundColor: kColorScaffold,
      appBar: appbar__widget(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SelectableButtons(numberOfButtons: numberOfWishes()),
              TitleBar__widget(title: 'Near from you', ontap: () {}, visibility: false),
              CardVerticalSmart(filter: widget.filter), // Accessing filter using widget.filter
              kSizedBoxHeight_16,
            ],
          ),
        ),
      ),
    );
  }
}
