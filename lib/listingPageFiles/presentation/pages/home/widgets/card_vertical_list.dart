import 'package:flutter/material.dart';
import 'package:turkify_bem/listingPageFiles/presentation/pages/home/widgets/personDetails.dart';
import '../../../../../personList.dart';
import '../../../../core/utils/navigator.dart';
import '../../../../gen/assets.gen.dart';
import '../../details_page/view/details.dart';
import 'list_card.dart';

class CaerdVerticalList__widget extends StatelessWidget {
  CaerdVerticalList__widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(persons.length >= 3 ? 3 : persons.length, (index) {
        Person personn = persons[index];
        return Padding(
          padding: EdgeInsets.only(right: 16), // Adjust spacing between items
          child: ListCardItem__widget(
            ontap: () => PageNav().push(context, ScreenDetails(person: personn)),
            title: personn.name,
            subText: personn.offer1.skill,
            imageLink: personn.imageLink,
          ),
        );
      }),
    );
  }
}
