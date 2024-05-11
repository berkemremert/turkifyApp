import 'package:flutter/material.dart';

import '../../../components/text.dart';
import '../../../themes/colors.dart';

class TitleBar__widget extends StatelessWidget {
  const TitleBar__widget({
    Key? key,
    required this.title,
    required this.ontap,
    this.visibility = true,
    this.textToDirect,
  }) : super(key: key);

  final String title;
  final ontap;
  final bool visibility;
  final String? textToDirect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          LabelSmall__text(text: title),
          const Spacer(),
          GestureDetector(
            onTap: ontap,
            child: Visibility(
                visible: visibility,
                child: BodySmall__text(
                    text: textToDirect?? 'See more', color: kColorText2)),
          ),
        ],
      ),
    );
  }
}
