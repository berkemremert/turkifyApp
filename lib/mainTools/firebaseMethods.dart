import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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

getDictWordByWord(String word) async {
  var wordDoc = await FirebaseFirestore.instance.collection('dictionary').where('word', isEqualTo: word).get();
  if (wordDoc.docs.isNotEmpty) {
    return wordDoc.docs.first.data() as Map<String, dynamic>;
  } else {
    return null;
  }
}

getWordOfTheDay(String date) async {
  var word = (await FirebaseFirestore.instance.collection('wordOfTheDay').doc(date).get() as Map<String, dynamic>)["word"];
  var wordDoc = await FirebaseFirestore.instance.collection('dictionary').where('word', isEqualTo: word).get();
  if (wordDoc.docs.isNotEmpty) {
    return wordDoc.docs.first.data() as Map<String, dynamic>;
  } else {
    return null;
  }
}

getAnimalandPicture (int dayOfTheMonth) async {
  NumberFormat formatter = new NumberFormat("000");
  var wordDoc = await FirebaseFirestore.instance.collection('dictWithPictures').doc(formatter.format(dayOfTheMonth.toString())).get() as Map<String, dynamic>;
  return wordDoc;

}

getProverb (int dayOfTheMonth) async {
  NumberFormat formatter = new NumberFormat("000");
  var wordDoc = await FirebaseFirestore.instance.collection('proverbs').doc(formatter.format(dayOfTheMonth.toString())).get() as Map<String, dynamic>;
  return wordDoc;
}