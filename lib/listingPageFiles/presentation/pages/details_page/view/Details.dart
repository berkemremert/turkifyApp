import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:turkify_bem/listingPageFiles/presentation/pages/home/view/TutorsPresentation.dart';
import 'package:turkify_bem/mainTools/constLinks.dart';
import '../../../../../mainTools/APPColors.dart';
import '../../../components/button.dart';
import '../../../components/text.dart';
import '../widgets/HeaderImage.dart';
import '../../../themes/colors.dart';
import '../../../themes/config.dart';

class ScreenDetails extends StatefulWidget {
  final String uid;

  ScreenDetails({Key? key, required this.uid}) : super(key: key);

  @override
  _ScreenDetailsState createState() => _ScreenDetailsState();
}

class _ScreenDetailsState extends State<ScreenDetails> {
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic> _userData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      Map<String, dynamic>? userData = await getUserData(widget.uid);
      if (userData != null) {
        _userData = userData;
      }
    } catch (e) {
      print('Error retrieving user data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    return Scaffold(
      backgroundColor: kColorScaffold,
      body: Stack(
        children: [
          if (_isLoading)
            Center(child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(baseDeepColor),
            ))
          else
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    kSizedBoxHeight_16,
                    HeaderImage__widget(
                      imageLink: _userData['profileImageUrl']?? profileDefaultBig,
                      name: _userData['name']?? 'Tutor Name',
                      offer: TutorsPresentationState().getEducationLevels(_userData),
                    ),
                    kSizedBoxHeight_24,
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: baseDeepColor.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const LabelSmall__text(text: 'Who am I?',
                            color: Colors.white,),
                          kSizedBoxHeight_16,
                          RichText(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              text: (_userData['tutorMap'] != null && _userData['tutorMap'] != []) ?_userData['tutorMap']['whoamI'] : 'No description.',
                              style: kBodySmallTextstylee,
                            ),
                          ),
                        ],
                      ),
                    ),
                    kSizedBoxHeight_24,
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1), // Adjust the opacity as needed
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            // REFERENCE PAGE
                            MaterialPageRoute(builder: (context) => Container()),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'References',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple, // Text color
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '3.4',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple, // Text color
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    kSizedBoxHeight_24,
                    GestureDetector(
                      onTap: () {
                        print("aaaa");
                      },
                      child: Container(),
                    )
                  ],
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            child: Container(
              width: ScreenConfig.screenWidth,
              decoration: BoxDecoration(
                color: kColorWhite,
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.6, 1.0],
                  colors: [
                    kColorWhite,
                    kColorWhite.withOpacity(0.0),
                  ],
                ),
              ),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        BodyMedium__text(text: "${_userData['name']} teaches", color: black),
                        kSizedBoxHeight_8,
                        LabelMedium__text(text: TutorsPresentationState().getEducationLevels(_userData)),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.2),
                          offset: Offset(0, 15),
                          blurRadius: 15,
                        ),
                      ]),
                      child: Accent__Button__Medium(
                        text: 'Send Request',
                        leftIconVisibility: false,
                        rightIconVisibility: false,
                        onTap: () {
                        //   TODO:
                        //   DENİZ BURAYA EKLE
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<Map<String, dynamic>?> getUserData(String documentId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(documentId)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
        userSnapshot.data() as Map<String, dynamic>;
        return userData;
      } else {
        return null;
      }
    } catch (e) {
      print('Error retrieving user data: $e');
      return null;
    }
  }
}