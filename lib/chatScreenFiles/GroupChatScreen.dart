// import 'dart:io';
// import 'dart:math';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:mime/mime.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:turkify_bem/mainTools/personList.dart';
// import 'package:uuid/uuid.dart';
//
// import 'package:turkify_bem/chatScreenFiles/Message.dart';
//
// class ChatPage extends StatefulWidget {
//   final Map<String, dynamic> data;
//   final String friendId;
//   const ChatPage({super.key, required this.data, required this.friendId});

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }
//
// class _ChatPageState extends State<ChatPage> {
//   List<MyTextMessage> _messages = [];
//   List<types.TextMessage> _newMessages = [];
//   final _user1 = FirebaseAuth.instance.currentUser;
//   final types.User _user = types.User(
//     id: FirebaseAuth.instance.currentUser!.uid,
//   );
//   Map<String, dynamic> get data => widget.data;
//   String get friendId => widget.friendId;
//
//
//   @override
//   void initState() {
//     super.initState();
//     _loadMessages();
//   }
//
//   void _addMessage(MyTextMessage message) {
//     setState(() {
//       _messages.insert(0, message);
//     });
//     String documentName = (1000000000000000 - message.createdAt).toString();
//     print("AAAAAAAAAAAAAAAAAAAAAAA $documentName");
//     FirebaseFirestore.instance.collection('messages').doc(documentName).set(message.toJson());
//     // FirebaseFirestore.instance.collection('meetingTimes').add("bırakıyom");
//     // TODO:
//   //   BANA TARIHLERI HANGI FORMATTA KAYDETTIIGINI SOYLEMEYI UNUTMA!!!!
//   }
//
//   void _handleAttachmentPressed() {
//     showModalBottomSheet<void>(
//       context: context,
//       builder: (BuildContext context) => SafeArea(
//         child: SizedBox(
//           height: 144,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   _handleImageSelection();
//                 },
//                 child: const Align(
//                   alignment: AlignmentDirectional.centerStart,
//                   child: Text('Photo'),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   _handleFileSelection();
//                 },
//                 child: const Align(
//                   alignment: AlignmentDirectional.centerStart,
//                   child: Text('File'),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Align(
//                   alignment: AlignmentDirectional.centerStart,
//                   child: Text('Cancel'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _handleFileSelection() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.any,
//     );
//
//     if (result != null && result.files.single.path != null) {
//       final message = types.FileMessage(
//         author: _user,
//         createdAt: DateTime.now().millisecondsSinceEpoch,
//         id: const Uuid().v4(),
//         mimeType: lookupMimeType(result.files.single.path!),
//         name: result.files.single.name,
//         size: result.files.single.size,
//         uri: result.files.single.path!,
//       );
//
//       _addMessage(message as MyTextMessage);
//     }
//   }
//
//   void _handleImageSelection() async {
//     final result = await ImagePicker().pickImage(
//       imageQuality: 70,
//       maxWidth: 1440,
//       source: ImageSource.gallery,
//     );
//
//     if (result != null) {
//       final bytes = await result.readAsBytes();
//       final image = await decodeImageFromList(bytes);
//
//       final message = types.ImageMessage(
//         author: _user,
//         createdAt: DateTime.now().millisecondsSinceEpoch,
//         height: image.height.toDouble(),
//         id: const Uuid().v4(),
//         name: result.name,
//         size: bytes.length,
//         uri: result.path,
//         width: image.width.toDouble(),
//       );
//
//       _addMessage(message as MyTextMessage);
//     }
//   }
//
//   void _handleMessageTap(BuildContext _, types.Message message) async {
//     if (message is types.FileMessage) {
//       var localPath = message.uri;
//
//       if (message.uri.startsWith('http')) {
//         try {
//           final index =
//               _messages.indexWhere((element) => element.authorID == message.id);
//           final updatedMessage =
//               (_messages[index] as types.FileMessage).copyWith(
//             isLoading: true,
//           );
//
//           setState(() {
//             _messages[index] = updatedMessage as MyTextMessage;
//           });
//
//           final client = http.Client();
//           final request = await client.get(Uri.parse(message.uri));
//           final bytes = request.bodyBytes;
//           final documentsDir = (await getApplicationDocumentsDirectory()).path;
//           localPath = '$documentsDir/${message.name}';
//
//           if (!File(localPath).existsSync()) {
//             final file = File(localPath);
//             await file.writeAsBytes(bytes);
//           }
//         } finally {
//           final index =
//               _messages.indexWhere((element) => element.authorID == message.id);
//           final updatedMessage =
//               (_messages[index] as types.FileMessage).copyWith(
//             isLoading: null,
//           );
//
//           setState(() {
//             _messages[index] = updatedMessage as MyTextMessage;
//           });
//         }
//       }
//
//       await OpenFilex.open(localPath);
//     }
//   }
//
//   void _handlePreviewDataFetched(
//     types.TextMessage message,
//     types.PreviewData previewData,
//   ) {
//     final index = _messages.indexWhere((element) => element.authorID == message.id);
//     final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
//       previewData: previewData,
//     );
//
//     setState(() {
//       _messages[index] = updatedMessage as MyTextMessage;
//     });
//   }
//
//   void _handleSendPressed(types.PartialText message) async {
//     String curID = _user1?.uid ?? "-";
//     String roomID = "";
//
//     if (_user1 != null) {
//       final curUsernameSnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(curID)
//           .get();
//       final curUsernameData = curUsernameSnapshot.data();
//       final String curUsername = curUsernameData?['username'] ?? "";
//
//       final String recipientUsername = data['username'];
//
//       if (curUsername.compareTo(recipientUsername) <= 0) {
//         roomID = '$curUsername${data['username']}';
//       } else {
//         roomID = '${data['username']}$curUsername';
//       }
//     }
//     final textMessage = MyTextMessage(
//         createdAt: DateTime.now().microsecondsSinceEpoch,
//         authorID: const Uuid().v4(),
//         text: message.text,
//     );
//     // final textMessage = types.TextMessage(
//     //   author: _user,
//     //   createdAt: DateTime.now().millisecondsSinceEpoch,
//     //   id: const Uuid().v4(),
//     //   text: message.text,
//     //   roomId: roomID,
//     // );
//
//     _addMessage(textMessage);
//   }
//
//   void _loadMessages() async {
//     final messagesSnapshot = await FirebaseFirestore.instance.collection('messages').get();
//     String wantID = "";
//     String curID = _user1?.uid ?? "-";
//     var messages = <MyTextMessage>[];
//     var newMessages = <types.TextMessage>[];
//
//
//     if(curID.compareTo(friendId) <= 0){
//       wantID = curID + friendId;
//     }
//     else{
//       wantID = friendId + curID;
//     }
//
//     messagesSnapshot.docs.forEach((doc) {
//       if (doc.id == wantID) {
//         Map<String, dynamic> messageData = doc.data();
//         messageData.values.forEach((data) {
//           try {
//             MyTextMessage message = MyTextMessage.fromJson(data);
//             messages.add(message);
//           }
//           catch(e){
//             print("ERROR $e");
//           }
//         });
//       }
//     });
//     messages.forEach((element) {
//       if (_user1 != null){
//         newMessages.add(types.TextMessage(author: _user, id: element.authorID, text: element.text));
//       }
//     });
//
//     newMessages.forEach((element) {
//       print("AAAAAAAAAAAAAAA: ${element.text}");
//     });
//     setState(() {
//       _messages = messages;
//       _newMessages = newMessages;
//     });
//   }
//
//
//
//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//     appBar: AppBar(
//       title: Text(data['name']),
//     ),
//         body: Chat(
//           messages: _newMessages,
//           onAttachmentPressed: _handleAttachmentPressed,
//           onMessageTap: _handleMessageTap,
//           onPreviewDataFetched: _handlePreviewDataFetched,
//           onSendPressed: _handleSendPressed,
//           showUserAvatars: true,
//           showUserNames: true,
//           user: _user,
//         ),
//       );
//   }
// }

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:turkify_bem/chatScreenFiles/Message.dart';
import 'package:uuid/uuid.dart';
import 'package:bubble/bubble.dart';
import 'package:turkify_bem/mainTools/APPColors.dart';

class ChatPage extends StatefulWidget {
  final Map<String, dynamic> data;
  final String friendId;
  const ChatPage({super.key, required this.data, required this.friendId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  final _user1 = FirebaseAuth.instance.currentUser;
  final types.User _user = types.User(id: FirebaseAuth.instance.currentUser!.uid);
  Map<String, dynamic> get data => widget.data;
  String get friendId => widget.friendId;


  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _addMessage(types.Message message) async {
    String wantID = findID();
    int createdTime = message.createdAt!;
    String timeID = (100000000000000 - createdTime).toString();
    try {
      final messagesCollection = FirebaseFirestore.instance.collection('messages');
      final messageDoc = await messagesCollection.doc(wantID).get();

      if (messageDoc.exists) {
        await messagesCollection.doc(wantID).update({
          timeID: {
            'authorID': _user1?.uid ?? "-",
            'createdAt': createdTime,
            'id': message.id,
            'text': (message as types.TextMessage).text,
            'type': 'text',
          }
        });
      }
    }
    catch (e) {
      print('Error: $e');
    }
    setState(() {
      _messages.insert(0, message);
    });

    // FirebaseFirestore.instance.collection('messages').add(message.toJson());
    // FirebaseFirestore.instance.collection('meetingTimes').add("bırakıyom");
    // TODO:
    //   BANA TARIHLERI HANGI FORMATTA KAYDETTIIGINI SOYLEMEYI UNUTMA!!!!
  }
  // void _addMessage(MyTextMessage message) {
  //   setState(() {
  //     _messages.insert(0, message);
  //   });
  //   String documentName = (1000000000000000 - message.createdAt).toString();
  //   print("AAAAAAAAAAAAAAAAAAAAAAA $documentName");
  //   FirebaseFirestore.instance.collection('messages').doc(documentName).set(message.toJson());
  //   // FirebaseFirestore.instance.collection('meetingTimes').add("bırakıyom");
  //   // TODO:
  //   //   BANA TARIHLERI HANGI FORMATTA KAYDETTIIGINI SOYLEMEYI UNUTMA!!!!
  // }
  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
          _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
          (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
          _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
          (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
      types.TextMessage message,
      types.PreviewData previewData,
      ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) async {
    String curID = _user1?.uid ?? "-";
    String roomID = "";

    if (_user1 != null) {
      final curUsernameSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(curID)
          .get();
      final curUsernameData = curUsernameSnapshot.data();
      final String curUsername = curUsernameData?['username'] ?? "";

      final String recipientUsername = data['username'];

      if (curUsername.compareTo(recipientUsername) <= 0) {
        roomID = '$curUsername${data['username']}';
      } else {
        roomID = '${data['username']}$curUsername';
      }
    }

    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
      roomId: roomID,
    );

    _addMessage(textMessage);
  }

  String findID(){
    String wantID = "";
    String curID = _user1?.uid ?? "-";
    if(curID.compareTo(friendId) <= 0){
      wantID = curID + friendId;
    }
    else{
      wantID = friendId + curID;
    }
    print("wantID: $wantID");
    return wantID;
  }
  void _loadMessages() async {
    final messagesSnapshot =
    await FirebaseFirestore.instance.collection('messages').get();
    String wantID = findID();
    List<MyTextMessage> mapMessages = [];

    for (var doc in messagesSnapshot.docs) {
      if (doc.id == wantID) {
        Map<String, dynamic> messageData = doc.data();
        for (var data in messageData.values) {
          try {
            MyTextMessage message = MyTextMessage.fromJson(data);
            mapMessages.add(message);
          } catch (e) {
            print("ERROR $e");
          }
        }
      }
    }
    mapMessages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final List<types.Message> messages = [];
    for (var element in mapMessages) {
      var authorUser = element.authorID == _user.id
          ? _user
          : types.User(id: friendId);
      final message = types.TextMessage(
        author: authorUser,
        id: element.id,
        text: element.text,
        createdAt: element.createdAt,
      );
      messages.add(message);
    }
    for (var element in messages) {
      print("AAAAAAAAAAA ${element.createdAt}");
    }
    setState(() {
      _messages = messages;
    });
  }


  Widget _bubbleBuilder(
      Widget child, {
        required message,
        required nextMessageInGroup,
      }) =>
      Bubble(
        color: _user.id != message.author.id ||
            message.type == types.MessageType.image
            ? const Color(0xfff5f5f7)
            : baseDeepColor,
        showNip: false,
        borderColor: Colors.transparent,
        radius: const Radius.circular(12),
        padding: const BubbleEdges.symmetric(vertical: 0),
        elevation: 0,
        child: child,
      );

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(data['name']),
      ),
      body: Chat(
        messages: _messages,
        // theme: const DarkChatTheme(),
        onAttachmentPressed: _handleAttachmentPressed,
        onMessageTap: _handleMessageTap,
        onPreviewDataFetched: _handlePreviewDataFetched,
        onSendPressed: _handleSendPressed,
        showUserAvatars: true,
        showUserNames: true,
        bubbleBuilder: _bubbleBuilder,
        user: _user,
      ),
    );
  }
}