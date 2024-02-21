import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../../referencePageFiles/referencePage.dart';
import '../../../../core/utils/navigator.dart';

import '../../../../gen/assets.gen.dart';
import '../../../components/text.dart';
import '../../../themes/colors.dart';
import '../../../themes/config.dart';
import '../../home/widgets/personDetails.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


const double _stackPadding = 20.0;

class HeaderImage__widget extends StatelessWidget {
  final Person person;

  const HeaderImage__widget({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 5 / 4,
          child: Container(
            decoration: BoxDecoration(
              color: kColorText3,
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image:
                  NetworkImage(
                    person.imageLink,
                  ),),
            ),
          ),
        ),
        AspectRatio(
          aspectRatio: 5 / 4,
          child: Container(
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
              ),
            ),
          ),
        ),
        Positioned(
          top: _stackPadding,
          left: _stackPadding,
          child: GestureDetector(
            onTap: () => PageNav().pop(context),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Shadow color
                    spreadRadius: 2,  // Shadow spread radius
                    blurRadius: 4,    // Shadow blur radius
                    offset: Offset(0, 2), // Offset of the shadow
                  ),
                ],
              ),
              child: Icon(
                FontAwesomeIcons.circleXmark,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          top: _stackPadding,
          right: _stackPadding,
          child: GestureDetector(
            onTap: () {
              //FILL HERE -BERK
            },
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Shadow color
                    spreadRadius: 2,  // Shadow spread radius
                    blurRadius: 4,    // Shadow blur radius
                    offset: Offset(0, 2), // Offset of the shadow
                  ),
                ],
              ),
              child: Icon(
                FontAwesomeIcons.bars,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          left: _stackPadding,
          bottom: _stackPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TitleLarge__text(text: person.name, color: kColorWhite),
              kSizedBoxHeight_8,
              BodySmall__text(
                  text: person.offer1.skill,
                  color: kColorText3),
            ],
          ),
        ),
      ],
    );
  }
}

class BedAndBathSection extends StatelessWidget {
  const BedAndBathSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Row(
          children: [
            SquareIconButton__widget(icon: Assets.icons.bed.svg),
            kSizedBoxWidth_8,
            const BodySmall__text(text: '6 Bedroom', color: kColorText3),
          ],
        ),
        kSizedBoxWidth_32,
        Row(
          children: [
            SquareIconButton__widget(icon: Assets.icons.bath.svg),
            kSizedBoxWidth_8,
            const BodySmall__text(text: '4 Bathroom', color: kColorText3),
          ],
        ),
      ],
    );
  }
}

class RoundIconButton__widget extends StatelessWidget {
  const RoundIconButton__widget({
    Key? key,
    required this.icon,
    this.iconColor,
    this.bgColor,
  }) : super(key: key);

  final icon;
  final iconColor;
  final bgColor;

  static const double _size = 36.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        color: bgColor ?? kColorBlack.withOpacity(0.25),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: icon(height: 24.0, width: 24.0, color: iconColor ?? kColorWhite),
      ),
    );
  }
}

class SquareIconButton__widget extends StatelessWidget {
  const SquareIconButton__widget({
    Key? key,
    required this.icon,
    this.iconColor,
    this.bgColor,
  }) : super(key: key);

  final icon;
  final iconColor;
  final bgColor;

  static const double _size = 28.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        color: bgColor ?? kColorWhite.withOpacity(0.20),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: icon(height: 24.0, width: 24.0, color: iconColor ?? kColorWhite),
      ),
    );
  }
}
