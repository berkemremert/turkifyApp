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

import '../DashboardScreen.dart';
import '../loginMainScreenFiles/custom_route.dart';
import '../settingsPageFiles/settingsPage.dart';
import '../videoMeetingFiles/videoMeetingMain.dart';

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
  bool _isDarkMode = SettingsPage.getIsDarkMode();
  bool _isSelected = false;
  String _selectedMessageID = "";
  bool isTutor = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _loadCurrentUser();
  }
  void _loadCurrentUser() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isNotEmpty) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;
      setState(() {
        isTutor = userData?['isTutor'] ?? false;
      });
    }
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
        changeIsRead(messagesCollection, 1);
      }
    }
    catch (e) {
      print('Error: $e');
    }
  }
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
    // print("wantID: $wantID");
    return wantID;
  }
  void _loadMessages() {
    String wantID = findID();
    final messagesCollection = FirebaseFirestore.instance.collection('messages');

    messagesCollection.doc(wantID).snapshots().listen((snapshot) {
      if (snapshot.exists) {
          final messageData = snapshot.data() as Map<String, dynamic>;
          List<types.Message> messages = [];
          changeIsRead(messagesCollection, 0);
          messageData.values.forEach((data) {
            try {
              MyTextMessage message = MyTextMessage.fromJson(data);
              var authorUser = message.authorID == _user.id
                  ? _user
                  : types.User(id: friendId);
              final textMessage = types.TextMessage(
                author: authorUser,
                id: message.id,
                text: message.text,
                createdAt: message.createdAt,
              );
              messages.add(textMessage);
            } catch (e) {
              print("ERRORa $e");
            }
          });
          messages.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

          setState(() {
            _messages = messages;
          });
      }
    });
  }


  Widget _bubbleBuilder(
      Widget child, {
        required message,
        required nextMessageInGroup,
      }) {
    DateTime datetime = DateTime.fromMillisecondsSinceEpoch(message.createdAt!);
    String messageTime = (datetime.minute.toString().length == 2)
        ? '${datetime.hour}:${datetime.minute}'
        : '${datetime.hour}:0${datetime.minute}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Bubble(
          color: _user.id != message.author.id ||
              message.type == types.MessageType.image
              ? (_isDarkMode ? Color.fromARGB(255, 32, 63, 84) : const Color(0xfff5f5f7))
              : (_isDarkMode ? Color.fromARGB(255, 25, 120, 100) : baseDeepColor),
          // TODO: I sucked at choosing colors. HELP
          showNip: true,
          borderColor: Colors.transparent,
          radius: const Radius.circular(35),
          padding: const BubbleEdges.symmetric(vertical: 0),
          elevation: 0,
          child: child,
        ),
        Text(
          messageTime,
          style: TextStyle(
            color: lightGrey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  void _toggleMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }
  void _onMessageLongPress(BuildContext context, types.Message p1) {
    setState(() {
      if(p1.author.id == _user1!.uid) {
        _selectedMessageID = p1.id;
        _isSelected = true;
      }
      print("Long press $_isSelected , $_selectedMessageID");
    });
  }
  void _onBackgroundTap() {
    setState(() {
      _isSelected = false;
      _selectedMessageID = "";
      print("Background tap $_isSelected , $_selectedMessageID");
    });
  }
  void _deleteMessage() {
    String wantID = findID();

    final messagesCollection = FirebaseFirestore.instance.collection('messages');

    messagesCollection.doc(wantID).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        final messageData = snapshot.data() as Map<String, dynamic>;
        messageData.forEach((key, value) {
          try {
            if (value['id'] == _selectedMessageID) {
              messagesCollection.doc(wantID).update({
                key: FieldValue.delete(),
              });
              setState(() {
                _isSelected = false;
                _selectedMessageID = "";
              });
            }
          } catch(e){
            print("ERRORA $e");
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          data['name'],
          style: TextStyle(
              color: _isDarkMode ? white : black
          ),
        ),
        backgroundColor: _isDarkMode ? (_isSelected ? const Color.fromRGBO(28, 20, 143, 10) : const Color.fromRGBO(58, 50, 143, 10)) : (_isSelected ? Color.fromRGBO(176, 224, 230, 10) : white),
        actions: [
          Visibility(
            visible: _isSelected,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.delete),
                color: _isDarkMode ? white : kDefaultIconDarkColor,
                onPressed: _deleteMessage,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.videocam_outlined),
            color: _isDarkMode ? white : kDefaultIconDarkColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoMeetingPage(calleeId: _user1!.uid),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.event),
            color: _isDarkMode ? white : kDefaultIconDarkColor,
            onPressed: () {
              if(isTutor){
                openDialog();
              }
            },
          ),
          const SizedBox(width: 12)
        ],
      ),

      body: Chat(
        messages: _messages,
        theme: _isDarkMode ? const DarkChatTheme() : const DefaultChatTheme(),
        onAttachmentPressed: _handleAttachmentPressed,
        onMessageTap: _handleMessageTap,
        onPreviewDataFetched: _handlePreviewDataFetched,
        onSendPressed: _handleSendPressed,
        showUserAvatars: true,
        showUserNames: true,
        avatarBuilder: (data['profileImageUrl'] != null) ? _buildAvatarTrue : _buildAvatarFalse,
        bubbleBuilder: _bubbleBuilder,
        user: _user,
        onMessageLongPress: _onMessageLongPress,
        onBackgroundTap: _onBackgroundTap,
      ),
    );
  }

  Widget _buildAvatarTrue(types.User user) {
    String url = data['profileImageUrl'] as String;
    return CircleAvatar(
      backgroundImage: NetworkImage(url)
    );
  }
  Widget _buildAvatarFalse(types.User user) {
    return const CircleAvatar(
      backgroundImage: AssetImage('assets/defaultProfilePicture.jpeg'),
    );
  }

  Future openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create an Appointment"),
        content: const TextField(
          decoration: InputDecoration(hintText: 'Enter your desired time'),
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () {
              // TODO: Fill here accordingly
            },
            child: const Text(
              "Submit",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          )

        ],
      ),
  );

  Future<void> changeIsRead(CollectionReference<Map<String, dynamic>> messagesCollection, int mode) async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final docId = findID();
    final DocumentSnapshot<Map<String, dynamic>> docSnapshot = await messagesCollection.doc(docId).get();
    final halfLength = docId.length ~/ 2;

    if(mode == 0){
      try {
        if (docId.startsWith(userId)) {
          if(docSnapshot.data()?['isRead'] == 1) {
            await messagesCollection.doc(findID()).update({'isRead': 0});
          }
        } else {
          if(docSnapshot.data()?['isRead'] == 2) {
            await messagesCollection.doc(findID()).update({'isRead': 0});
          }
        }

      } catch (e) {
        print('Error updating document: $e');
      }
    }
    else if(mode == 1){
      try {
        if (docId.startsWith(userId)) {
          if(docSnapshot.data()?['isRead'] == 0) {
            await messagesCollection.doc(findID()).update({'isRead': 2});
          }
        } else {
          if(docSnapshot.data()?['isRead'] == 0) {
            await messagesCollection.doc(findID()).update({'isRead': 1});
          }
        }

      } catch (e) {
        print('Error updating document: $e');
      }
    }
  }
}