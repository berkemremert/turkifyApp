import 'package:flutter/material.dart';
import 'package:turkify_bem/listingPageFiles/presentation/pages/home/widgets/personDetails.dart';
import '../../../../../mainTools/personList.dart';
import '../../../../core/utils/navigator.dart';
import '../../../../gen/assets.gen.dart';
import '../../details_page/view/details.dart';
import 'list_card.dart';
import '../view/TutorsPresentation.dart';

class CardVerticalSmart extends StatelessWidget {
  List<Map<String, dynamic>> tutors;

  CardVerticalSmart({Key? key, required this.tutors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (Map<String, dynamic> tutor in tutors)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ListCardItem__widget(
              ontap: () => PageNav().push(context,
                  ScreenDetails(uid: '',)
              ),
              title: tutor['name']?? '',
              subText: TutorsPresentationState().getEducationLevels(tutor),
              imageLink: tutor['profileImageUrl']?? '',
            ),
          ),
      ],
    );
  }
}