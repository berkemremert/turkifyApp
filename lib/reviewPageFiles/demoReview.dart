import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:turkify_bem/mainTools/APPColors.dart';

class DemoReview extends StatefulWidget {
  final String uidTutor;

  DemoReview({required this.uidTutor});

  @override
  _DemoReviewState createState() => _DemoReviewState();
}

class _DemoReviewState extends State<DemoReview> {
  List<Map<String, dynamic>> reviews = [];
  double averageRating = 0.0;
  int totalReviews = 0;
  Map<int, double> ratingDistribution = {
    5: 0.0,
    4: 0.0,
    3: 0.0,
    2: 0.0,
    1: 0.0,
  };

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    await FirebaseFirestore.instance
        .collection('tutorPresentation')
        .doc(widget.uidTutor)
        .collection('reviews')
        .orderBy('date', descending: true)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        reviews = snapshot.docs
            .map((doc) => doc.data())
            .toList();
        _distribution();
      });
    });
  }

  void _distribution() {
    int fives = 0;
    int fours = 0;
    int threes = 0;
    int twos = 0;
    int ones = 0;
    int zeros = 0;
    int comments = reviews.length;

    for (Map<String, dynamic> review in reviews) {
      int rating = (review['rating'] as num).toInt();
      switch (rating) {
        case 5:
          fives++;
          break;
        case 4:
          fours++;
          break;
        case 3:
          threes++;
          break;
        case 2:
          twos++;
          break;
        case 1:
          ones++;
          break;
        default:
          zeros++;
          break; // If zero ratings are not valid, handle this case differently
      }
    }

    if (comments != 0) {
      averageRating = (5 * fives + 4 * fours + 3 * threes + 2 * twos + ones) / comments;
    } else {
      averageRating = 0.0;
    }

    print(averageRating);

    totalReviews = comments;
    ratingDistribution = {
      5: comments != 0 ? fives / comments : 0.0,
      4: comments != 0 ? fours / comments : 0.0,
      3: comments != 0 ? threes / comments : 0.0,
      2: comments != 0 ? twos / comments : 0.0,
      1: comments != 0 ? ones / comments : 0.0,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 5; i >= 1; i--)
                  RatingBarRow(rating: i, percentage: ratingDistribution[i] ?? 0),
              ],
            ),
            SizedBox(width: 16),
            Column(
              children: [
                Text(
                  averageRating.toStringAsFixed(1),
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 48,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: _buildStarRating(),
                ),
                Text('$totalReviews reviews', style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildStarRating() {
    int fullStars = averageRating.floor();
    bool hasHalfStar = (averageRating - fullStars) >= 0.5;

    List<Widget> stars = [];
    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(Icons.star, color: baseDeepColor, size: 24));
    }
    if (hasHalfStar) {
      stars.add(Icon(Icons.star_half, color: baseDeepColor, size: 24));
    }
    while (stars.length < 5) {
      stars.add(Icon(Icons.star_border, color: baseDeepColor, size: 24));
    }

    return stars;
  }
}

class RatingBarRow extends StatelessWidget {
  final int rating;
  final double percentage;

  RatingBarRow({required this.rating, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$rating',
          style: TextStyle(
              color: Colors.black54,
              fontSize: 16),
        ),
        SizedBox(width: 8),
        Stack(
          children: [
            Container(
              width: 150,
              height: 10,
              color: Colors.grey[200],
            ),
            Container(
              width: 150 * percentage,
              height: 10,
              color: baseDeepColor,
            ),
          ],
        ),
      ],
    );
  }
}