import 'package:flutter/material.dart';
import 'package:turkify_bem/mainTools/APPColors.dart';
import '../../../../gen/assets.gen.dart';
import '../../../components/text.dart';
import '../../../themes/colors.dart';
import '../../../themes/config.dart';

class ListCardItem__widget extends StatelessWidget {
  const ListCardItem__widget(
      {Key? key,
      required this.imageLink,
      required this.title,
      required this.ontap,
      required this.subText,})
      : super(key: key);

  final String imageLink;
  final ontap;
  final String title;
  final String subText;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: <Widget>[
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: baseDeepColor,
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(
                  imageLink,
                ),
                ),
              ),
            ),
            kSizedBoxWidth_24,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LabelMedium__text(text: title),
                kSizedBoxHeight_8,
                BodySmall__text(text: subText),
              ],
            )
          ],
        ),
      ),
    );
  }
}