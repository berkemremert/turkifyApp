import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:turkify_bem/mainTools/APPColors.dart';
import '../../../../core/utils/navigator.dart';
import '../../../components/text.dart';
import '../../details_page/view/Details.dart';
import '../widgets/TutorShowingVertical.dart';
import '../widgets/AppBar.dart';
import '../widgets/CardVertical.dart';
import '../widgets/SearchAndFilter.dart';
import '../../../themes/colors.dart';
import '../../../themes/config.dart';
import '../../../../../mainTools/constLinks.dart';

import '../widgets/TitleBar.dart';

class TutorsPresentation extends StatefulWidget {
  const TutorsPresentation({Key? key}) : super(key: key);

  @override
  TutorsPresentationState createState() => TutorsPresentationState();
}

class TutorsPresentationState extends State<TutorsPresentation> {
  late List<Map<String, dynamic>> tutors = [];
  late List<String> tutorUids = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTutors();
  }

  Future<void> loadTutors() async {
    List<Map<String, dynamic>> loadedTutors = await getTutorList();
    tutorUids = await getAllTutorUids();
    setState(() {
      Future.delayed(Duration(seconds: 3));
      _isLoading = false;
      tutors = loadedTutors;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);

    return Scaffold(
      backgroundColor: backGroundColor(),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 30,),
                  TitleBar__widget(
                    title: '  Best tutors for you',
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Scaffold(
                          backgroundColor: kColorScaffold,
                          appBar: appbar__widget(),
                          body: SafeArea(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  CardVerticalSmart(tutors: tutors,),
                                  kSizedBoxHeight_16,
                                ],
                              ),
                            ),
                          ),
                        )),
                      );
                    },
                  ),
                  ScrollConfiguration(
                    behavior: const ScrollBehavior(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Row(
                        children: List.generate(
                          tutors.length < 3 ? tutors.length : 3,
                              (index) {
                            Map<String, dynamic> tutor = tutors[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: GestureDetector(
                                onTap: () => PageNav().push(
                                  context,
                                  ScreenDetails(uid: tutorUids.elementAt(index)),
                                ),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 200,
                                      height: 250,
                                      decoration: BoxDecoration(
                                        color: baseDeepColor,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(tutor['profileImageUrl']?? profileDefaultBig),
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    Container(
                                      width: 200,
                                      height: 250,
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
                                    Positioned(
                                      right: 16,
                                      top: 16,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                                        decoration: BoxDecoration(
                                          color: kColorBlack.withOpacity(0.25),
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            BodySmall__text(text: tutor['rating']?? 'New Tutor', color: kColorWhite),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 20,
                                      bottom: 16,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          LabelSmall__text(text: tutor['name'], color: kColorWhite),
                                          kSizedBoxHeight_8,
                                          BodySmall__text(text: getEducationLevels(tutor), color: kColorText3),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  kSizedBoxHeight_8,
                  SearchAndFilter(),
                  kSizedBoxHeight_8,
                  TitleBar__widget(title: '  Filter tutors',
                      textToDirect: 'Filter',
                      ontap: () {

                      }),
                  TutorShowingVertical(),
                  kSizedBoxHeight_16,
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: backGroundColor(),
              child: Center(
                child: CircularProgressIndicator(
                  color: baseDeepColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
  Future<List<Map<String, dynamic>>> getUserList() async {
    List<Map<String, dynamic>> tutors = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users').get();
      if (querySnapshot.docs.isNotEmpty) {
        for (DocumentSnapshot doc in querySnapshot.docs) {
          DocumentSnapshot tutorDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(doc.id)
              .get();
          if (tutorDoc.exists) {
            Map<String, dynamic> tutorData =
            (tutorDoc.data() as Map<String, dynamic>);
            tutors.add(tutorData);
          }
        }
      }
    } catch (error) {
      print('Error fetching tutors: $error');
    }
    return tutors;
  }

  Future<List<Map<String, dynamic>>> getTutorList() async{
    List<Map<String, dynamic>> users = await getUserList();
    List<Map<String, dynamic>> tutors = [];

    for(Map<String, dynamic> user in users){
      if(user['isTutor']?? false){
        tutors.add(user);
      }
    }

    return tutors;
  }

  String getEducationLevels(Map<String, dynamic> tutor){
    List<String> levels = [];
    if(tutor['tutorMap'] != null && tutor['tutorMap']['teachingLevel'] != []) {
      for (String level in tutor['tutorMap']['teachingLevel']) {
        levels.add(level);
      }
    }

    String levelsString = levels.toString();
    levelsString = levelsString.substring(1, levelsString.length - 1);

    return levelsString;
  }

  Future<List<String>> getAllUids() async {
    List<String> documentNames = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          documentNames.add(doc.id);
        });
      }
    } catch (error) {
      print('Error fetching document names: $error');
    }
    return documentNames;
  }

  Future<List<String>> getAllTutorUids() async {
    List<String> tutorDocumentNames = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('isTutor', isEqualTo: true)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          tutorDocumentNames.add(doc.id);
        });
      }
    } catch (error) {
      print('Error fetching tutor document names: $error');
    }
    return tutorDocumentNames;
  }
}
