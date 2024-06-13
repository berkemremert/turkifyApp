import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:turkify_bem/mainTools/APPColors.dart';

class ReviewPage extends StatefulWidget {
  final String tutorUid;

  ReviewPage({required this.tutorUid});

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final TextEditingController _reviewController = TextEditingController();
  int? _rating;
  List<Map<String, dynamic>> reviews = [];
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    getUserData();
    _fetchReviews();
  }

  void getUserData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
    Map<String, dynamic> userData = (userDoc.data() as Map<String, dynamic>);
    _userData = userData;
    setState(() {});
  }

  bool studentTutorCheck(){
    List<dynamic>? friends = _userData['friends'];
    if(friends == null)
      return false;
    if(friends.contains(widget.tutorUid)) {
      for(Map<String, dynamic> review in reviews){
        if(review['username'] == _userData['username'] && review['level'] == _userData['studentMap']['desiredEducation'])
          return false;
      }
      return true;
    }
    return false;
  }

  Future<void> _fetchReviews() async {
    FirebaseFirestore.instance
        .collection('tutorPresentation')
        .doc(widget.tutorUid)
        .collection('reviews')
        .orderBy('date', descending: true)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        reviews = snapshot.docs
            .map((doc) => doc.data())
            .toList();
      });
    });
  }

  void _submitReview() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Rate your tutor'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < (_rating ?? 0) ? Icons.star : Icons.star_border,
                ),
                onPressed: () {
                  setState(() {
                    _rating = index + 1;
                  });
                  Navigator.pop(context);
                },
              );
            }),
          ),
        );
      },
    ).then((_) {
      if (_rating != null && _reviewController.text.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('tutorPresentation')
            .doc(widget.tutorUid)
            .collection('reviews')
            .add({
          'username': _userData['username'],
          'profilePicUrl' : _userData['profileImageUrl'],
          'rating': _rating,
          'date': DateTime.now().toString(),
          'comment': _reviewController.text,
          'level': _userData['studentMap']['desiredEducation'],
        });

        _reviewController.clear();
        setState(() {
          _rating = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: reviews.isEmpty
                  ? Center(
                child: Text('No review yet'),
              )
                  : ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(height: 10,),
                      _buildReviewItem(
                        reviews[index]['username'],
                        reviews[index]['rating'],
                        DateFormat('dd MMMM yyyy, EEEE').format(DateTime.parse(reviews[index]['date'])),
                        reviews[index]['comment'],
                        'Education level: ' + reviews[index]['level'],
                        reviews[index]['profilePicUrl'],
                      ),
                      SizedBox(height: 10,),
                      Divider(
                          indent: 30,
                          endIndent: 30,
                          color: Color.fromRGBO(229, 229, 229, 1.0)),
                    ],
                  );
                },
              ),
            ),
            studentTutorCheck() ? _buildReviewInput() : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewItem(
      String username, int rating, String date, String comment, String level, String profilePicUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            profilePicUrl.isNotEmpty
                ? CircleAvatar(
              backgroundColor: baseLightColor,
              backgroundImage: NetworkImage(profilePicUrl),
              radius: 30,
            )
                : CircleAvatar(
              backgroundColor: baseLightColor,
              radius: 30,
              backgroundImage: AssetImage('assets/defaultProfilePicture.jpeg'),
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: index < rating ? baseDeepColor : baseDeepColor,
                    );
                  }),
                ),
                Text(date),
              ],
            ),
          ],
        ),
        SizedBox(height: 20),
        ReviewComment(comment: comment),
        SizedBox(height: 8),
        TeachingLevel(level: level),
      ],
    );
  }

  Widget _buildReviewInput() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(right: 8),
            child: TextField(
              controller: _reviewController,
              decoration: InputDecoration(
                hintText: 'Write a review..',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: _submitReview,
        ),
      ],
    );
  }
}

class ReviewComment extends StatelessWidget {
  final String comment;

  ReviewComment({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.grey[200],
      child: Text(comment),
    );
  }
}

class TeachingLevel extends StatelessWidget {
  final String level;

  TeachingLevel({required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.grey[100],
      child: Text(level, style: TextStyle(color: Colors.grey[700])),
    );
  }
}
