import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'signaling.dart';

class VideoMeetingPage extends StatefulWidget {
  VideoMeetingPage({Key? key}) : super(key: key);

  @override
  _VideoMeetingPageState createState() => _VideoMeetingPageState();
}

class _VideoMeetingPageState extends State<VideoMeetingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  TextEditingController textEditingController =
  TextEditingController(text: '');

  bool _cameraOpened = false;
  String? userId;

  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();

    _getCurrentUserId();

    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });

    _checkIfBeingCalled();

    super.initState();
  }

  Future<void> _getCurrentUserId() async {
    User? user = _auth.currentUser;
    if (user != null) {
      userId = user.uid;
    }
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  Future<String?> isBeingCalled(String userId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    var callSnapshot = await db
        .collection('currentCalls')
        .where('calleeId', isEqualTo: userId)
        .get();

    if (callSnapshot.docs.isNotEmpty) {
      return callSnapshot.docs.first.id;
    } else {
      return null;
    }
  }

  Future<void> _checkIfBeingCalled() async {
    if (userId != null) {
      String? roomId = await isBeingCalled(userId!);
      if (roomId != null) {
        signaling.openUserMedia(_localRenderer, _remoteRenderer);
        await Future.delayed(Duration(seconds: 1));
        await signaling.joinRoom(roomId, _remoteRenderer);
        textEditingController.text = roomId;
        setState(() {
          _cameraOpened = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Meeting Page Turkify"),
        elevation: 5,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey), // Add border
                      ),
                      child: RTCVideoView(_localRenderer, mirror: true),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: RTCVideoView(_remoteRenderer),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Join the following Room: ",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(width: 8),
                Flexible(
                  child: TextFormField(
                    controller: textEditingController,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 8),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () async{
                      signaling.openUserMedia(_localRenderer, _remoteRenderer);
                      await Future.delayed(Duration(seconds: 1));
                      setState(() {
                        _cameraOpened = true;
                      });
                      },
                    icon: Icon(Icons.videocam),
                    color: Colors.white,
                  ),
                  IconButton(
                    onPressed: () async {
                      roomId = await signaling.createRoom(
                        _remoteRenderer, userId!, "fMY0J7iFHydYK9yf2lqAx2Ue4gn1",
                      );
                      textEditingController.text = roomId!;
                      setState(() {});
                    },
                    icon: Icon(Icons.phone),
                    color: Colors.white,
                  ),
                  // IconButton(
                  //   onPressed: () {
                  //     signaling.joinRoom(
                  //       textEditingController.text.trim(),
                  //       _remoteRenderer,
                  //     );
                  //   },
                  //   icon: Icon(Icons.join_full),
                  //   color: Colors.white,
                  // ),
                  IconButton(
                    onPressed: () async {
                      signaling.hangUp(_localRenderer);
                      await FirebaseFirestore.instance.collection('currentCalls').doc(roomId).delete();
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.phone_disabled),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}