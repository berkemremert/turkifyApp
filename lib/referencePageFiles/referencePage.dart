import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../listingPageFiles/presentation/pages/home/widgets/personDetails.dart';
import '../personList.dart';

void main() {
  runApp(MyApp());
}

class Comment {
  final String comment;
  final double stars;
  final Person person;

  Comment({required this.comment, required this.stars, required this.person});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comment Widget',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CommentPage(),
    );
  }
}

class CommentPage extends StatefulWidget {
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final List<Comment> comments = [];

  TextEditingController commentController = TextEditingController();
  double selectedStars = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('References'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                Comment currentComment = comments[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(currentComment.person.imageLink),
                  ),
                  title: Row(
                    children: [
                      Text(currentComment.person.name),
                      SizedBox(width: 10),
                      RatingBarIndicator(
                        rating: currentComment.stars,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 20.0,
                        direction: Axis.horizontal,
                      ),
                    ],
                  ),
                  subtitle: Text(currentComment.comment),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    //textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: '  Write a reference',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                RatingBar.builder(
                  initialRating: selectedStars,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 30.0,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      selectedStars = rating;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Add comment to the list
                    setState(() {
                      comments.add(Comment(
                        comment: commentController.text,
                        stars: selectedStars,
                        person: persons[0],
                      ));
                      commentController.clear();
                      selectedStars = 0;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}