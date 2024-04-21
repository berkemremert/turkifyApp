import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendsListScreen extends StatefulWidget {
  const FriendsListScreen({super.key});

  @override
  _FriendsListScreenState createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {
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
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                child: const CircularProgressIndicator(),
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
              onTap: () {
              //TODO:
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
                      CircleAvatar(
                        backgroundImage: imageChecker
                            ? NetworkImage(friendImageUrl as String)
                            : const AssetImage('assets/defaultProfilePicture.jpeg') as ImageProvider<Object>,
                        radius: 30.0,
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        friendName,
                        style: const TextStyle(fontSize: 16.0),
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
