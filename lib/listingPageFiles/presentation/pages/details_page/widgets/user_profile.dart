import 'package:flutter/material.dart';
import '../../../../gen/assets.gen.dart';
import '../../../components/text.dart';
import 'header_image.dart';
import '../../../themes/colors.dart';
import '../../../themes/config.dart';

class UserProfile__widget extends StatelessWidget {
  const UserProfile__widget({Key? key}) : super(key: key);

  static const double _avatarSize = 40.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: _avatarSize,
          width: _avatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kColorText3,
            image:
                DecorationImage(image: AssetImage(Assets.images.avatar.path)),
          ),
        ),
        kSizedBoxWidth_16,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LabelMedium__text(text: 'Garry Allen'),
            SizedBox(height: 4),
            BodySmall__text(text: 'Owner'),
          ],
        ),
        const Spacer(),
        SquareIconButton__widget(
          icon: Assets.icons.phone.svg,
          bgColor: kColorAccent.withOpacity(0.5),
        ),
        kSizedBoxWidth_16,
        SquareIconButton__widget(
          icon: Assets.icons.chat.svg,
          bgColor: kColorAccent.withOpacity(0.5),
        ),
      ],
    );
  }
}
