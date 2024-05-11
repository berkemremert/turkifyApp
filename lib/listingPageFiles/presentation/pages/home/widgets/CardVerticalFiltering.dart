import 'package:flutter/material.dart';
import '../../../../../mainTools/APPColors.dart';
import '../../../../../mainTools/constLinks.dart';
import '../../../../core/utils/navigator.dart';
import '../../details_page/view/Details.dart';
import 'ListCard.dart';
import '../view/TutorsPresentation.dart';

class CardVerticalFiltering extends StatefulWidget {
  final List<Map<String, dynamic>> tutors;

  CardVerticalFiltering({Key? key, required this.tutors}) : super(key: key);

  @override
  _CardVerticalFilteringState createState() => _CardVerticalFilteringState();
}

class _CardVerticalFilteringState extends State<CardVerticalFiltering> {
  late Future<List<String>> tutorUids;

  @override
  void initState() {
    super.initState();
    tutorUids = TutorsPresentationState().getAllTutorUids();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: tutorUids,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(baseDeepColor),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<String> tutorUids = snapshot.data!;
          return Column(
            children: [
              for (int i = 0; i < widget.tutors.length; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ListCardItem__widget(
                    ontap: () => PageNav().push(
                      context,
                      ScreenDetails(uid: tutorUids[i]),
                    ),
                    title: widget.tutors[i]['name'] ?? 'Tutor name',
                    subText: TutorsPresentationState().getEducationLevels(widget.tutors[i]),
                    imageLink: widget.tutors[i]['profileImageUrl'] ?? profileDefaultBig,
                  ),
                ),
            ],
          );
        }
      },
    );
  }
}