import 'package:flutter/material.dart';
import 'package:turkify_bem/listingPageFiles/presentation/pages/home/widgets/CardVertical.dart';
import 'package:turkify_bem/listingPageFiles/presentation/pages/home/widgets/CardVerticalFiltering.dart';
import '../../../themes/config_files/values.dart';
import '../view/TutorsPresentation.dart';

class TutorShowingVertical extends StatefulWidget {
  TutorShowingVertical({Key? key}) : super(key: key);

  @override
  _TutorShowingVerticalState createState() => _TutorShowingVerticalState();
}

class _TutorShowingVerticalState extends State<TutorShowingVertical> {
  late List<Map<String, dynamic>> tutors = [];
  late List<String> tutorUids = [];

  @override
  void initState() {
    super.initState();
    loadTutors();
  }

  Future<void> loadTutors() async {
    List<Map<String, dynamic>> loadedTutors = await TutorsPresentationState().getTutorList();
    tutorUids = await TutorsPresentationState().getAllTutorUids();
    setState(() {
      tutors = loadedTutors;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            CardVerticalSmart(tutors: tutors, numberToShow: 6,),
            kSizedBoxHeight_16,
          ],
        ),
      ),
    );
  }
}
