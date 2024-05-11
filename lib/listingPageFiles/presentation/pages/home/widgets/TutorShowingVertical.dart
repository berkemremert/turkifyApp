import 'package:flutter/material.dart';
import '../../../../core/utils/navigator.dart';
import '../../../../gen/assets.gen.dart';
import '../../details_page/view/Details.dart';
import 'ListCard.dart';

class TutorShowingVertical extends StatelessWidget {
  TutorShowingVertical({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          // persons.length >= 3 ? 3 : persons.length
          3
          , (index) {
        return Padding(
          padding: EdgeInsets.only(right: 16), // Adjust spacing between items
          child:
          // ListCardItem__widget(
          //   ontap: () => PageNav().push(context,
          //       ScreenDetails(person: personn)),
          //   title: personn.name,
          //   subText: personn.offer1.skill,
          //   imageLink: personn.imageLink,
          // ),
          Container(),
        );
      }),
    );
  }
}
