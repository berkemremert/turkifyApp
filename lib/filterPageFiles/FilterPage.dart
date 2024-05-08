import 'package:flutter/material.dart';
import 'package:turkify_bem/filterPageFiles/languageLevel.dart';

import '../cardSlidingScreenFiles/cardSlider.dart';
import '../mainTools/APPColors.dart';
import '../mainTools/imagedButton.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FilterState();
  }
}


class _FilterState extends State<FilterPage>
    with TickerProviderStateMixin {
    late AnimationController controller;
    // late Animation<double> _animation10;
    // late Animation<double> _animation11;
    // late Animation<double> _animation12;
    // late Animation<double> _animation13;



    @override
    Widget build(BuildContext context) {
      // var _loadingController = AnimationController(
      //   vsync: this,
      //   duration: const Duration(milliseconds: 1250),
      //   value: 1,
      // );
      return Scaffold(
        backgroundColor: backGroundColor(),
        body: Center(
          child: Column(
              children: [
                const SizedBox(height: 30),
                ImagedButton(imagePath: 'assets/callLightRed.png', buttonText: "A1", onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScaffoldWidget(
                        title: '',
                        child: LanguageLevel(),
                      ),
                    ),
                  );
                }),
              ],
            ),
        ),
      );
    }
  }




