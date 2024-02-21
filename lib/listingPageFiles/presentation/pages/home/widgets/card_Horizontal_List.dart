import 'package:flutter/material.dart';
import 'package:turkify_bem/listingPageFiles/presentation/pages/home/widgets/personDetails.dart';
import '../../../../core/utils/navigator.dart';
import '../../../../gen/assets.gen.dart';
import '../../../components/text.dart';
import '../../details_page/view/details.dart';
import '../../../themes/colors.dart';
import '../../../themes/config.dart';
import 'package:turkify_bem/personList.dart';

class CardHorizontalList__widget extends StatelessWidget {
  CardHorizontalList__widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    distanceListCreator();

    return ScrollConfiguration(
      behavior: const ScrollBehavior(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: List.generate(personsDistance.length > 3 ? 3 : personsDistance.length, (index) {
            Person personn = personsDistance[index];
            return Padding(
              padding: EdgeInsets.only(right: 16), // Adjust spacing between items
              child: CardListItem(
                ontap: () => PageNav().push(context, ScreenDetails(person: personn)),
                distance: personn.distance.toString(),
                title: personn.name,
                offer1: personn.offer1.skill,
                imageLink: personn.imageLink,
              ),
            );
          }),
        ),
      ),
    );
  }
}

///
///
///
class DistanceChips extends StatelessWidget {
  const DistanceChips({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: kColorBlack.withOpacity(0.25),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: <Widget>[
          Assets.icons.location.svg(color: kColorWhite),
          BodySmall__text(text: text, color: kColorWhite),
        ],
      ),
    );
  }
}

class CardListItem extends StatelessWidget {
  const CardListItem({
    Key? key,
    required this.distance,
    required this.title,
    required this.offer1,
    this.offer2,
    this.offer3,
    required this.imageLink,
    required this.ontap,
  }) : super(key: key);

  final String distance;
  final String title;
  final String offer1;
  final String? offer2;
  final String? offer3;
  final String imageLink;
  final ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Stack(
        children: [
          Container(
            width: 200,
            height: 250,
            decoration: BoxDecoration(
              color: kColorText3,
              image:
              // DecorationImage(fit: BoxFit.cover,
              //   image: NetworkImage(
              //     'https://images.pexels.com/photos/1036623/pexels-photo-1036623.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
              //   ),)
                  DecorationImage(fit: BoxFit.cover, image: NetworkImage(
                    imageLink,
                  ),
                  ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          Container(
            width: 200,
            height: 250,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.2, 1.0],
                  colors: [
                    kColorBlack.withOpacity(0.7),
                    kColorWhite.withOpacity(0.0),
                  ],
                )),
          ),
          Positioned(
            right: 16,
            top: 16,
            child: DistanceChips(
              text: distance + ' km',
            ),
          ),
          Positioned(
            left: 20,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LabelSmall__text(text: title, color: kColorWhite),
                kSizedBoxHeight_8,
                BodySmall__text(text: offer1, color: kColorText3),
              ],
            ),
          )
        ],
      ),
    );
  }
}
