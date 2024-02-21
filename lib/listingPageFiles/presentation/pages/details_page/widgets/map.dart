import 'package:flutter/material.dart';
import '../../../../gen/assets.gen.dart';
import '../../../themes/colors.dart';

class Map__widget extends StatelessWidget {
  const Map__widget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Container(
        decoration: BoxDecoration(
          color: kColorText2,
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(Assets.images.map.path),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
