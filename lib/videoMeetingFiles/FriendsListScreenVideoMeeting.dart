import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:turkify_bem/mainTools/APPColors.dart';
import 'package:turkify_bem/videoMeetingFiles/videoMeetingMain.dart';

class FriendsListScreenVideoMeeting extends StatefulWidget {
  @override
  _FriendsListScreenVideoMeetingState createState() => _FriendsListScreenVideoMeetingState();
}

class _FriendsListScreenVideoMeetingState extends State<FriendsListScreenVideoMeeting> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  List<String> _friendUids = [];

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _getUser() async {
    _user = _auth.currentUser;
    if (_user != null) {
      _fetchFriends();
    }
  }

  void _fetchFriends() async {
    final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
    await _firestore.collection('users').doc(_user!.uid).get();

    final userData = userSnapshot.data();

    if (userData != null && userData.containsKey('friends')) {
      setState(() {
        _friendUids = List<String>.from(userData['friends']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildFriendsList(),
    );
  }

  Widget _buildFriendsList() {
    return GridView.builder(
      padding: EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: _friendUids.length,
      itemBuilder: (context, index) {
        return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: _firestore.collection('users').doc(_friendUids[index]).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 50.0,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(baseDeepColor),
                ),
              );
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final friendData = snapshot.data?.data();
            final friendName = friendData?['name'] ?? 'Unnamed';
            final friendImageUrl = friendData?['profileImageUrl'];
            final bool imageChecker = friendImageUrl != null;

            return GestureDetector(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoMeetingPage(calleeId: _friendUids[index]),
                  ),
                );
              },
              child: Card(
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 6.0,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundImage: imageChecker
                              ? NetworkImage(friendImageUrl as String)
                              : AssetImage('assets/defaultProfilePicture.jpeg') as ImageProvider<Object>,
                          radius: 40.0,
                        ),
                      ),
                      SizedBox(height: 13.0),
                      Text(
                        friendName,
                        style: TextStyle(
                            fontSize: 20.0,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
