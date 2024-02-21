import 'package:flutter/material.dart';

import '../../../../../personList.dart';
import '../view/seeAllNear.dart';

class SelectableButtons extends StatelessWidget {
  final int numberOfButtons;

  SelectableButtons({required this.numberOfButtons});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Expand container to screen width
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _buildButtons(context),
      ),
    );
  }

  List<Widget> _buildButtons(context) {
    List<Widget> buttons = [];
    List<String> skills = [currentUser.wish1.skill];

    if(currentUser.wish2 != null){
      skills.add(currentUser.wish2!.skill);
    }
    if(currentUser.wish3 != null){
      skills.add(currentUser.wish3!.skill);
    }

    void pop(int buttonOrder){
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => SeeAllNear(filter: buttonOrder,),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }

    for (int i = 0; i < numberOfButtons; i++) {
      buttons.add(
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              if(i == 0){
                pop(1);
              }
              else if(i == 1){
                pop(2);
              }
              else if(i == 2){
                pop(3);
              }
            },
            child: Text(
              skills[i],
              overflow: TextOverflow.ellipsis, // Handle text overflow
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              elevation: 4, // Add elevation for shadow
            ),
          ),
        ),
      );

      // Add space between buttons
      if (i < numberOfButtons - 1) {
        buttons.add(SizedBox(width: 8.0));
      }
    }
    return buttons;
  }
}