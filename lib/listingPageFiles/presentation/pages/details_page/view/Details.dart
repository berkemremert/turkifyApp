import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:turkify_bem/listingPageFiles/presentation/pages/home/view/TutorsPresentation.dart';
import 'package:turkify_bem/mainTools/constLinks.dart';
import '../../../../../chatScreenFiles/GroupChatScreen.dart';
import '../../../../../mainTools/APPColors.dart';
import '../../../../../mainTools/firebaseMethods.dart';
import '../../../../../reviewPageFiles/ReviewPage.dart';
import '../../../../../reviewPageFiles/demoReview.dart';
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
        setState(() {
          _userData = userData;
        });
      }
    } catch (e) {
      print('Error retrieving user data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addFriend(String friendId) async {
    try {
      // Update current user's friends list
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
        'friends': FieldValue.arrayUnion([friendId]),
      });

      // Update friend's friends list
      await FirebaseFirestore.instance.collection('users').doc(friendId).update({
        'friends': FieldValue.arrayUnion([user!.uid]),
      });

      print('Added $friendId as a friend.');
    } catch (e) {
      print('Error adding friend: $e');
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backGroundColor(),
          title: Text('Send Request', style: TextStyle(color: baseDeepColor)),
          content: Text('Do you want to send an automated request message?', style: TextStyle(color: Colors.black54)),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.black54)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Send', style: TextStyle(color: baseDeepColor)),
              onPressed: () {
                Navigator.of(context).pop();
                _addFriend(widget.uid);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(data: _userData, friendId: widget.uid),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    return Scaffold(
      backgroundColor: kColorScaffold,
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(baseDeepColor),
              ),
            )
                : SingleChildScrollView(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 50,),
                  HeaderImage__widget(
                    imageLink: _userData['profileImageUrl'] ?? profileDefaultBig,
                    name: _userData['name'] ?? 'Tutor Name',
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
                        const LabelSmall__text(
                          text: 'Who am I?',
                          color: Colors.white,
                        ),
                        kSizedBoxHeight_16,
                        RichText(
                          text: TextSpan(
                            text: (_userData['tutorMap'] != null &&
                                _userData['tutorMap'] != [])
                                ? _userData['tutorMap']['whoamI'] + '\n\n' + _userData['tutorMap']['whoamIEng']
                                : 'No description.',
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
                          MaterialPageRoute(builder: (context) => ReviewPage(tutorUid: widget.uid,)),
                        );
                      },
                      child: DemoReview(uidTutor: widget.uid,),
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
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: kColorWhite,
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: const [0.6, 1.0],
                colors: [
                  kColorWhite,
                  kColorWhite.withOpacity(0.0),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      BodyMedium__text(text: "${_userData['name']} teaches", color: black),
                      kSizedBoxHeight_8,
                      LabelMedium__text(
                        text: TutorsPresentationState().getEducationLevels(_userData),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.2),
                        offset: const Offset(0, 15),
                        blurRadius: 15,
                      ),
                    ]),
                    child: Accent__Button__Medium(
                      text: 'Send Request',
                      leftIconVisibility: false,
                      rightIconVisibility: false,
                      onTap: _showConfirmationDialog,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}