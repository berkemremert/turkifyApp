import 'package:flutter/material.dart';
import '../../../../core/utils/navigator.dart';

import '../../../components/text.dart';
import '../../../themes/colors.dart';
import '../../../themes/config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


const double _stackPadding = 20.0;

class HeaderImage__widget extends StatelessWidget {
  final String imageLink;
  final String name;
  final String offer;

  const HeaderImage__widget({Key? key,
  required this.imageLink,
    required this.name,
    required this.offer,
  }) : super(key: key);

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
                    imageLink,
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
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
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
              final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
              final Offset offset = Offset(overlay.size.width, 100);

              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(offset.dx, offset.dy, 0, 0),
                items: [
                  PopupMenuItem<String>(
                    value: 'Option 1',
                    child: Text('Option 1'),
                  ),
                  PopupMenuItem<String>(
                    value: 'Option 2',
                    child: Text('Option 2'),
                  ),
                  PopupMenuItem<String>(
                    value: 'Option 3',
                    child: Text('Option 3'),
                  ),
                ],
              ).then((value) {
                if (value != null) {
                  print(value);
                }
              });
            },
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 2),
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
              TitleLarge__text(text: name, color: kColorWhite),
              kSizedBoxHeight_8,
              BodySmall__text(
                  text: offer,
                  color: kColorText3),
            ],
          ),
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