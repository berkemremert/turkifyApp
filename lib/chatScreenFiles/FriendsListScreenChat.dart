import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../mainTools/APPColors.dart';
import 'GroupChatScreen.dart';

// Widget for displaying a list of friends for chat
class FriendsListScreenChat extends StatefulWidget {
  const FriendsListScreenChat({super.key});
  @override
  _FriendsListScreenChatState createState() => _FriendsListScreenChatState();
}

// State class for the FriendsListScreenChat widget
class _FriendsListScreenChatState extends State<FriendsListScreenChat> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Authentication instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  User? _user; // Current logged-in user
  List<String> _friendUids = []; // List of friend UIDs
  Map<String, bool> isReadMap = {}; // Map to track read/unread status of messages

  @override
  void initState() {
    super.initState();
    _getUser(); // Get the current user when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildFriendsList(), // Build the friends list UI
    );
  }

  // Widget to build the friends list UI
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
            final friendId = _friendUids[index];
            final friendImageUrl = friendData?['profileImageUrl'];
            final bool imageChecker = friendImageUrl != null;
            bool isRead = isReadMap[friendId] ?? false;
            print("$friendName ${isReadMap[friendId]}");
            return GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(data: friendData!, friendId: friendId),
                  ),
                );
                _fetchFriends(); // Refresh the friends list after returning from chat screen
              },
              child: Card(
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: white,
                child: Center(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 100.0,
                              width: 100.0,
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: white,
                                        width: 6.0,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      backgroundImage: imageChecker
                                          ? NetworkImage(friendImageUrl as String)
                                          : const AssetImage('assets/defaultProfilePicture.jpeg')
                                      as ImageProvider<Object>,
                                      radius: 40.0,
                                    ),
                                  ),
                                  if (!isRead)
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Container(
                                        width: 20.0,
                                        height: 20.0,
                                        decoration: const BoxDecoration(
                                          color: Color.fromARGB(255, 236, 13, 13),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              friendName,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ],
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

  // Function to create and update the isReadMap
  void _createIsRead() async {
    final messagesCollection = FirebaseFirestore.instance.collection('messages');
    messagesCollection.snapshots().listen((snapshot) {
      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data.containsKey('isRead')) {
          final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
          final docId = doc.id;
          final halfLength = docId.length ~/ 2;

          String key;
          if (docId.startsWith(userId)) {
            key = docId.substring(halfLength);
            setState(() {
              if (data['isRead'] == 1) {
                isReadMap[key] = false;
              } else {
                isReadMap[key] = true;
              }
            });
          } else {
            key = docId.substring(0, halfLength);
            setState(() {
              if (data['isRead'] == 2) {
                isReadMap[key] = false;
              } else {
                isReadMap[key] = true;
              }
            });
          }
        }
      }
    });
  }

  // Function to get the current user
  void _getUser() async {
    _user = _auth.currentUser;
    if (_user != null) {
      _fetchFriends(); // Fetch friends if the user is logged in
    }
  }

  // Function to fetch friends from Firestore
  void _fetchFriends() async {
    final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
    await _firestore.collection('users').doc(_user!.uid).get();

    final userData = userSnapshot.data();

    if (userData != null && userData.containsKey('friends')) {
      setState(() {
        _friendUids = List<String>.from(userData['friends']); // Update friend UIDs
      });
    }
    _createIsRead(); // Initialize read/unread status map
  }
}
