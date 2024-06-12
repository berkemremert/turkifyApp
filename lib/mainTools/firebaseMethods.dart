import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firebaseInstance = FirebaseFirestore.instance;

CollectionReference<Map<String, dynamic>> getMessages(){
  CollectionReference<Map<String, dynamic>> messagesCollection = firebaseInstance.collection('messages');
  return messagesCollection;
}

FirebaseFirestore getInstance() {
  return FirebaseFirestore.instance;
}

getUserData(String userId) async {
  DocumentSnapshot userSnapshot = await firebaseInstance.collection('users').doc(userId).get();
  return userSnapshot.data() as Map<String, dynamic>?;
}

getMessageDoc(CollectionReference<Map<String, dynamic>> messagesCollection, String wantID){
  return messagesCollection.doc(wantID).get();
}

getDictWord(String id) async {
  DocumentSnapshot wordDoc = await FirebaseFirestore.instance.collection('dictionary').doc(id).get();
  return wordDoc.data() as Map<String, dynamic>?;
}
