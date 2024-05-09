import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BlockedPage extends StatefulWidget {
  final List<dynamic> blockedList;
  const BlockedPage({Key? key, required this.blockedList}) : super(key: key);

  @override
  State<BlockedPage> createState() => _BlockedPageState();
}

class _BlockedPageState extends State<BlockedPage> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.blockedList.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> userData = _userInfo(widget.blockedList[index]);
          return ListTile(
            title: Text('${userData['firstName']} ${userData['lastName']}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // setState(() async {
                //   FirebaseFirestore firestore = FirebaseFirestore.instance;
                //   DocumentReference userRef = firestore.collection('users').doc(FirebaseAuth.instance.currentUser?.uid ?? '');
                //   DocumentSnapshot userSnapshot = await userRef.get();
                //   List<dynamic> blockedUsers = userSnapshot.data()['blocked_users'];
                  widget.blockedList.removeAt(index);
                //   await userRef.update({'blocked_users': blockedUsers});
                // });
              },
            ),
          );
        },
      ),
    );
  }

  _userInfo(String id) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot userSnapshot = await firestore.collection('users').doc(id).get();
    if (userSnapshot.exists) {
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

      String name = userData['name'];
      String surname = userData['surname'];
      return {
        'name' : name,
        'surname' : surname,
        'id': id
      };
    } else {
      print('User with ID $id does not exist.');
    }
  }
}
