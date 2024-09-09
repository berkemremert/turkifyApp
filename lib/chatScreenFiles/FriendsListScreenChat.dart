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
        crossAxisCount: 2, // 2 friends per row
        crossAxisSpacing: 10.0, // Spacing between friends horizontally
        mainAxisSpacing: 10.0, // Spacing between friends vertically
      ),
      itemCount: _friendUids.length, // Total number of friends
      itemBuilder: (context, index) {
        return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: _firestore.collection('users').doc(_friendUids[index]).get(), // Fetch friend data from Firestore
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while the data is being fetched
              return Container(
                height: 50.0,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(baseDeepColor),
                ),
              );
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // Display an error message if something goes wrong
            }

            final friendData = snapshot.data?.data();
            final friendName = friendData?['name'] ?? 'Unnamed'; // Friend's name
            final friendId = _friendUids[index]; // Friend's ID
            final friendImageUrl = friendData?['profileImageUrl']; // Friend's profile picture URL
            final bool imageChecker = friendImageUrl != null; // Check if the friend has a profile picture
            bool isRead = isReadMap[friendId] ?? false; // Check if the message from this friend has been read

            return GestureDetector(
              onTap: () async {
                // Navigate to chat page when friend card is tapped
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(data: friendData!, friendId: friendId),
                  ),
                );
                _fetchFriends(); // Refresh the friends list after returning from the chat screen
              },
              child: Card(
                elevation: 3.0, // Elevation for card shadow effect
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners for the card
                ),
                color: white, // Card background color
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
                                  // Friend's profile picture inside a circular avatar
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
                                  // Red dot indicating unread message
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
                            const SizedBox(height: 10.0), // Spacing between profile picture and name
                            Text(
                              friendName, // Display friend's name
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

  // Function to create and update the isReadMap (message read/unread status)
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
            key = docId.substring(halfLength); // Extract friend's ID from document ID
            setState(() {
              if (data['isRead'] == 1) {
                isReadMap[key] = false; // Message is unread
              } else {
                isReadMap[key] = true; // Message is read
              }
            });
          } else {
            key = docId.substring(0, halfLength); // Extract friend's ID from document ID
            setState(() {
              if (data['isRead'] == 2) {
                isReadMap[key] = false; // Message is unread
              } else {
                isReadMap[key] = true; // Message is read
              }
            });
          }
        }
      }
    });
  }

  // Function to get the current user from FirebaseAuth
  void _getUser() async {
    _user = _auth.currentUser;
    if (_user != null) {
      _fetchFriends(); // Fetch the user's friends if logged in
    }
  }

  // Function to fetch friends from Firestore based on current user's friend list
  void _fetchFriends() async {
    final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
    await _firestore.collection('users').doc(_user!.uid).get();

    final userData = userSnapshot.data();

    if (userData != null && userData.containsKey('friends')) {
      setState(() {
        _friendUids = List<String>.from(userData['friends']); // Populate friend UIDs
      });
    }
    _createIsRead(); // Initialize the isReadMap for tracking unread messages
  }
}

// © 2024 Berk Emre Mert and EğiTeam
