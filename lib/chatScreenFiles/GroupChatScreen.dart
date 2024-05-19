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

import '../mainTools/firebaseMethods.dart';
import '../settingsPageFiles/settingsPageTutor.dart';
import '../videoMeetingFiles/videoMeetingMain.dart';

class ChatPage extends StatefulWidget {
  final Map<String, dynamic> data;
  final String friendId;
  const ChatPage({super.key, required this.data, required this.friendId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

//State of Chat Page
class _ChatPageState extends State<ChatPage> {
  final _currentUser = FirebaseAuth.instance.currentUser; // current user
  final types.User _user = types.User(id: FirebaseAuth.instance.currentUser!.uid); // current user
  final bool _isDarkMode = SettingsPageTutor.getIsDarkMode(); // dark mode controller

  late CollectionReference<Map<String, dynamic>> messagesCollection = getMessages();
  late FirebaseFirestore firebaseInstance;

  String _selectedMessageID = ""; // selected message
  bool isTutor = false; // tutor checker
  bool _isSelected = false; // selected checker
  List<types.Message> _messages = []; // message list

  String get friendId => widget.friendId; // other persons id getter
  Map<String, dynamic> get data => widget.data; // data getter

  @override
  void initState() {
    super.initState();
    _loadMessages(); // first load previous messages
    _loadCurrentUser(); // load current users info
    // messagesCollection = getMessages();
    firebaseInstance = getInstance();
  }

  // HELPER FUNCTIONS vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
  void _loadCurrentUser() async { // to initiate isTutor
    String userId = _currentUser?.uid ?? '';
    if (userId.isNotEmpty) {
      Map<String, dynamic>? userData = getUserData(userId);
      setState(() {
        isTutor = userData?['isTutor'] ?? false;
      });
    }
  }

  String findID(){ // to find the room id needed. It concatenates two users' ids according to alphabetical order
    String wantID = "";
    String curID = _currentUser?.uid ?? "-";
    if(curID.compareTo(friendId) <= 0){ // compare alphabetically
      wantID = curID + friendId;
    }
    else{
      wantID = friendId + curID;
    }
    return wantID;
  }

  Widget _buildAvatarTrue(types.User user) { // creates avatar if valid url exists
    String url = data['profileImageUrl'] as String;
    return CircleAvatar(
        backgroundImage: NetworkImage(url)
    );
  }
  Widget _buildAvatarFalse(types.User user) { // creates avatar if valid url does not exist
    return const CircleAvatar(
      backgroundImage: AssetImage('assets/defaultProfilePicture.jpeg'),
    );
  }

  Future<void> changeIsRead(CollectionReference<Map<String, dynamic>> messagesCollection, int mode) async { // function to change isRead
    final userId = _currentUser?.uid ?? '';
    final docId = findID();
    final DocumentSnapshot<Map<String, dynamic>> docSnapshot = getMessageDoc(messagesCollection, docId);

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
  //HELPER FUNCTIONS ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

  // ADD AND LOAD vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
  Future<void> _addMessage(types.Message message) async { // Add message
    String wantID = findID();
    int createdTime = message.createdAt!;
    String timeID = (100000000000000 - createdTime).toString(); // for sorting purposes, created time is subtracted from 10^14
    try {
      final messageDoc = await getMessageDoc(messagesCollection, wantID); // get the message document with the id wantID
      if (messageDoc.exists) {
        await messagesCollection.doc(wantID).update({ // update according to the map given
          timeID: {
            'authorID': _currentUser?.uid ?? "-",
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
  void _loadMessages() {
    String wantID = findID(); // get the wanted ID

    messagesCollection.doc(wantID).snapshots().listen((snapshot) {
      /*
        Listen to any changes in the chat, reload the messages if any change is detected, uses streams for real time messaging
       */
      if (snapshot.exists) {
        final messageData = snapshot.data() as Map<String, dynamic>;
        List<types.Message> messages = [];
        changeIsRead(messagesCollection, 0);
        for (var data in messageData.values) { // for all messages in the snapshot
          try {
            MyTextMessage message = MyTextMessage.fromJson(data); // create a message in the format that is compatible with the Chat widget
            var authorUser = message.authorID == _user.id // if this is sent by us
                ? _user // author is us
                : types.User(id: friendId); // otherwise the other person
            final textMessage = types.TextMessage( // creating the text message variable with necessary fields
              author: authorUser,
              id: message.id,
              text: message.text,
              createdAt: message.createdAt,
            );
            messages.add(textMessage); // add this to the messages list which will later given to Chat widget
          } catch (e) {
            print("ERRORa $e");
          }
        }
        messages.sort((a, b) => b.createdAt!.compareTo(a.createdAt!)); // reverse sorting so that all messages are shown according to the sended time

        setState(() { // set state
          _messages = messages;
        });
      }
    });
  }
  // ADD AND LOAD ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

  // HANDLES vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
  void _handleAttachmentPressed() { // for handling attachment pressed
    // Show a bottom sheet with options for selecting an image or a file
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Button for selecting a photo
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
              // Button for selecting a file
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
              // Button for cancelling the operation
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

  void _handleFileSelection() async { // for handling file selection
    // Open file picker and allow the user to select a file
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    // If a file is selected, create a file message and add it to the chat
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

  void _handleImageSelection() async { // for handling image selection
    // Open image picker and allow the user to select an image from the gallery
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    // If an image is selected, create an image message and add it to the chat
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

  void _handleMessageTap(BuildContext _, types.Message message) async { // for handling message tap
    if (message is types.FileMessage) {
      var localPath = message.uri;

      // If the file URI is a remote URL, download the file
      if (message.uri.startsWith('http')) {
        try {
          // Find the message in the list and mark it as loading
          final index =
          _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
          (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          // Download the file
          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          // Save the file locally
          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          // Mark the message as not loading anymore
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

      // Open the file
      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
      types.TextMessage message,
      types.PreviewData previewData,
      ) {
    // Find the message in the list and update it with the fetched preview data
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) async { // for handling send pressed
    String curID = _currentUser?.uid ?? "-";
    String roomID = "";

    if (_currentUser != null) {
      // Fetch the current user's username
      final curUsernameSnapshot = await firebaseInstance
          .collection('users')
          .doc(curID)
          .get();
      final curUsernameData = curUsernameSnapshot.data();
      final String curUsername = curUsernameData?['username'] ?? "";

      final String recipientUsername = data['username'];

      // Generate a room ID based on the usernames of the sender and recipient
      if (curUsername.compareTo(recipientUsername) <= 0) {
        roomID = '$curUsername${data['username']}';
      } else {
        roomID = '${data['username']}$curUsername';
      }
    }

    // Create a text message and add it to the chat
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
      roomId: roomID,
    );

    _addMessage(textMessage);
  }

  void _onMessageLongPress(BuildContext context, types.Message p1) { // for handling long press on a message
    setState(() {
      // Check if the long-pressed message is authored by the current user
      if(p1.author.id == _currentUser!.uid) {
        // Set the selected message ID and mark a message as selected
        _selectedMessageID = p1.id;
        _isSelected = true;
      }
      print("Long press $_isSelected , $_selectedMessageID");
    });
  }

  void _onBackgroundTap() { // for handling tap on background
    setState(() {
      // Deselect any selected message
      _isSelected = false;
      _selectedMessageID = "";
      print("Background tap $_isSelected , $_selectedMessageID");
    });
  }

  void _deleteMessage() { // for handling message deletion
    // Find the document ID that contains the message to be deleted
    String wantID = findID();
    messagesCollection.doc(wantID).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        // Retrieve message data from the snapshot
        final messageData = snapshot.data() as Map<String, dynamic>;
        messageData.forEach((key, value) {
          try {
            // Check if the message ID matches the selected message ID
            if (value['id'] == _selectedMessageID) {
              // Delete the message field from the document
              messagesCollection.doc(wantID).update({
                key: FieldValue.delete(),
              });
              setState(() {
                // Deselect the message after deletion
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


  // HANDLES ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

  Future openDialog() => showDialog( // for showing dialog to create an appointment
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
            // Action to take when the submit button is pressed
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

  Widget _bubbleBuilder( // for building message bubble
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
              ? (_isDarkMode ? const Color.fromARGB(255, 32, 63, 84) : const Color(0xfff5f5f7))
              : (_isDarkMode ? const Color.fromARGB(255, 25, 120, 100) : baseDeepColor),
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

  @override
  Widget build(BuildContext context) { // for building the chat screen
    return Scaffold(
      appBar: AppBar(
        title: Text(
          data['name'],
          style: TextStyle(
              color: _isDarkMode ? white : black
          ),
        ),
        backgroundColor: _isDarkMode ? (_isSelected ? const Color.fromRGBO(28, 20, 143, 10) : const Color.fromRGBO(58, 50, 73, 10)) : (_isSelected ? const Color.fromRGBO(176, 224, 230, 10) : white),
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
                  builder: (context) => VideoMeetingPage(calleeId: _currentUser!.uid),
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
}