import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../mainTools/APPColors.dart';
import '../../../../../referencePageFiles/referencePage.dart';
import '../../../components/button.dart';
import '../../../components/text.dart';
import '../widgets/header_image.dart';
import '../widgets/image_gallery.dart';
import '../widgets/map.dart';
import '../widgets/user_profile.dart';
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
                      imageLink: _userData['profileImageUrl']?? '',
                      name: _userData['name']?? 'No name',
                      offer: 'A1',
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
                            MaterialPageRoute(builder: (context) => CommentPage()),
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
                      child: const Map__widget(),
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
                        BodyMedium__text(text: "${_userData['name']} offering", color: kColorText2),
                        kSizedBoxHeight_8,
                        LabelMedium__text(text: 'skill'),
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
                        text: 'Match Now',
                        leftIconVisibility: false,
                        rightIconVisibility: false,
                        onTap: () {},
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