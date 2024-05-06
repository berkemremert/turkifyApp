import 'package:cloud_firestore/cloud_firestore.dart';

class MyTextMessage {
  final String authorID;
  final String type;
  final String id;
  final String text;
  final int createdAt;

  MyTextMessage({required this.createdAt, required this.authorID, required this.text, required this.type, required this.id});

  factory MyTextMessage.fromSnapshot(DocumentSnapshot snapshot) {
    return MyTextMessage(
      authorID: snapshot.id,
      text: snapshot['text'],
      type: "text",
      id: snapshot['id'],
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  factory MyTextMessage.fromJson(Map<String, dynamic> json) {
    return MyTextMessage(
      authorID: json['authorID'],
      text: json['text'],
      createdAt: json['createdAt'],
      type: "text",
      id: json['id'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'authorID': authorID,
      'text': text,
      'createdAt': createdAt,
      'id': id,
      'type': type,
    };
  }
}
