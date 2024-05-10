import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/navigator.dart';
import '../../../../gen/assets.gen.dart';
import '../../../components/text.dart';
import '../../details_page/view/details.dart';
import '../widgets/TutorShowingVertical.dart';
import '../widgets/appbar.dart';
import '../widgets/cardVerticalSmart.dart';
import '../widgets/search_and_filter.dart';
import '../../../themes/colors.dart';
import '../../../themes/config.dart';

import '../widgets/title_bar.dart';

class TutorsPresentation extends StatefulWidget {
  const TutorsPresentation({Key? key}) : super(key: key);

  @override
  _TutorsPresentationState createState() => _TutorsPresentationState();
}

class _TutorsPresentationState extends State<TutorsPresentation> {
  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);

    return Scaffold(
      backgroundColor: kColorScaffold,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SearchAndFilter(),
              kSizedBoxHeight_8,
              TitleBar__widget(
                title: 'Best tutors for you',
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
                              CardVerticalSmart(), // Accessing filter using widget.filter
                              kSizedBoxHeight_16,
                            ],
                          ),
                        ),
                      ),
                    )
                    ),
                  );
                },
              ),
              TutorShowingHorizontal(),
              kSizedBoxHeight_8,
              TitleBar__widget(title: 'Friends profiles', ontap: () {
              }),
              TutorShowingVertical(),
              kSizedBoxHeight_16,
            ],
          ),
        ),
      ),
    );
  }
}

class TutorShowingHorizontal extends StatefulWidget {
  TutorShowingHorizontal({Key? key}) : super(key: key);

  @override
  _TutorShowingHorizontalState createState() => _TutorShowingHorizontalState();
}

class _TutorShowingHorizontalState extends State<TutorShowingHorizontal> {
  late List<Map<String, dynamic>> tutors = [];

  @override
  void initState() {
    super.initState();
    loadTutors();
  }

  Future<void> loadTutors() async {
    List<Map<String, dynamic>> loadedTutors = await getTutorList();
    tutors = loadedTutors;
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: List.generate(
            tutors.length > 3 ? 3 : tutors.length,
                (index) {
              Map<String, dynamic> tutor = tutors[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CardListItem(
                  ontap: () => PageNav().push(
                    context,
                    ScreenDetails(uid: tutor['uid']),
                  ),
                  rating: tutor['rating'].toString(),
                  title: tutor['name'],
                  offer1: tutor['offer1'],
                  imageLink: tutor['profileImageUrl'],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getTutorList() async {
    List<Map<String, dynamic>> tutors = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('isTutor', isEqualTo: true)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        tutors = querySnapshot.docs.map((doc) {
          return {
            'uid': doc.id,
            'name': doc['name'],
            'rating': doc['rating'],
            'offer1': doc['offer1'],
            'profileImageUrl': doc['profileImageUrl'],
          };
        }).toList();
      }
    } catch (error) {
      print('Error fetching tutors: $error');
    }
    return tutors;
  }
}

class DistanceChips extends StatelessWidget {
  const DistanceChips({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: kColorBlack.withOpacity(0.25),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: <Widget>[
          Assets.icons.location.svg(color: kColorWhite),
          BodySmall__text(text: text, color: kColorWhite),
        ],
      ),
    );
  }
}

class CardListItem extends StatelessWidget {
  const CardListItem({
    Key? key,
    required this.rating,
    required this.title,
    required this.offer1,
    this.offer2,
    this.offer3,
    required this.imageLink,
    required this.ontap,
  }) : super(key: key);

  final String rating;
  final String title;
  final String offer1;
  final String? offer2;
  final String? offer3;
  final String imageLink;
  final ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Stack(
        children: [
          Container(
            width: 200,
            height: 250,
            decoration: BoxDecoration(
              color: kColorText3,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  imageLink,
                ),
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
            child: DistanceChips(
              text: rating,
            ),
          ),
          Positioned(
            left: 20,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LabelSmall__text(text: title, color: kColorWhite),
                kSizedBoxHeight_8,
                BodySmall__text(text: offer1, color: kColorText3),
              ],
            ),
          )
        ],
      ),
    );
  }
}