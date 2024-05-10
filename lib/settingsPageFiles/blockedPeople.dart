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
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.blockedList.length,
        itemBuilder: (context, index) {
          return FutureBuilder(
            future: _userInfo(widget.blockedList[index]),
            builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              Map<String, dynamic>? userData = <String, dynamic>{};
              if(snapshot.data != null){
                userData = snapshot.data;
              }
              return ListTile(
                title: Text('${userData?['firstName']} ${userData?['lastName']}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    setState(() {
                      widget.blockedList.removeAt(index);
                    });
                    final FirebaseFirestore firestore = FirebaseFirestore.instance;
                    final DocumentReference userRef = firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
                    await userRef.update({'blockedPeople': widget.blockedList});
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _userInfo(String id) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot userSnapshot = await firestore.collection('users').doc(id).get();
    if (userSnapshot.exists) {
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
      String name = userData['name'];
      String surname = userData['surname'];
      return {
        'firstName': name,
        'lastName': surname,
        'id': id
      };
    } else {
      print('User with ID $id does not exist.');
      throw Exception('User not found');
    }
  }
}
