import 'package:flutter/material.dart';
import 'package:turkify_bem/listingPageFiles/presentation/pages/home/widgets/personDetails.dart';
import '../../../../../personList.dart';
import '../../../../core/utils/navigator.dart';
import '../../../../gen/assets.gen.dart';
import '../../details_page/view/details.dart';
import 'list_card.dart';

class CardVerticalSmart extends StatelessWidget {
  int filter;

  CardVerticalSmart({Key? key, this.filter = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int index = 0; index < persons.length; index++)
          if(isAdd(filter, persons[index]))
          Padding(
            padding: EdgeInsets.only(right: 16), // Adjust spacing between items
            child: ListCardItem__widget(
              ontap: () => PageNav().push(context, ScreenDetails(person: persons[index])),
              title: persons[index].name,
              subText: persons[index].offer1.skill,
              imageLink: persons[index].imageLink,
            ),
          ),
      ],
    );
  }
}

bool isAdd(int filter, Person person){
  if(person.email == currentUser.email){
    return false;
  }
  else if(filter == 0){
    return true;
  }
  else if(filter == 1 && offerList(person).contains(wishList(currentUser)[0])){
    return true;
  }
  else if(filter == 2 && offerList(person).contains(wishList(currentUser)[1])){
    return true;
  }
  else if(filter == 3 && offerList(person).contains(wishList(currentUser)[2])){
    return true;
  }
  return false;
}
