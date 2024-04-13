import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'signaling.dart';

class VideoMeetingPage extends StatefulWidget {
  final String calleeId;

  VideoMeetingPage({Key? key, required this.calleeId}) : super(key: key);

  @override
  _VideoMeetingPageState createState() => _VideoMeetingPageState();
}

class _VideoMeetingPageState extends State<VideoMeetingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  late StreamSubscription<DocumentSnapshot> _subscription;

  bool _isTutor = false;
  bool _calleeCameraOpened = false;
  bool _calleeMicOpened = false;

  bool _cameraOpened = false;
  bool _micOpened = false;
  String? userId;
  bool _isBeingCalled = false;

  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();

    _getCurrentUserId();

    _isTutorCheck();

    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });

    signaling.openUserMedia(_localRenderer, _remoteRenderer);

    _checkIfBeingCalled();

    _subscribeToCalls();

    super.initState();
  }

  Future<void> _isTutorCheck() async{
    FirebaseFirestore db = FirebaseFirestore.instance;

    DocumentSnapshot<Map<String, dynamic>> snapshot = await db
        .collection('users')
        .doc(userId)
        .get();

    _isTutor = snapshot.data()?['isTutor'];
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
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _subscribeToCalls() async {
    _subscription = FirebaseFirestore.instance
        .collection('currentCalls')
        .doc(roomId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        setState(() {
          _calleeCameraOpened = snapshot.data()?['calleeCamera'];
          _calleeMicOpened = snapshot.data()?['calleeMic'];
          _onCall(roomId!);
        });
      }
    });
  }

  void _onCall(String roomId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('currentCalls').doc(roomId).update({
      'callerCamera': _cameraOpened,
      'callerMic' : _micOpened,
    });
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
      String? roomIdLocal = await isBeingCalled(userId!);
      if (roomIdLocal != null) {
        signaling.openUserMedia(_localRenderer, _remoteRenderer);
        await Future.delayed(Duration(seconds: 1));
        await signaling.joinRoom(roomIdLocal, _remoteRenderer);
        setState(() {
          roomId = roomIdLocal;
          _subscribeToCalls();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 40),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: (_isBeingCalled ? _cameraOpened : _calleeCameraOpened)
                          ?
                      RTCVideoView(_localRenderer, mirror: true) :
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: const Center(
                          child: Text(
                            'Your camera\nis off',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: (_isBeingCalled ? _calleeCameraOpened : _cameraOpened)
                          ? RTCVideoView(_remoteRenderer)
                          : Center(
                        child: Text(
                          _isTutor ?
                          'Student\'s camera\nis off' :
                          'Tutor\'s camera\nis off',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
                  if(roomId != null)
                    IconButton(
                      onPressed: () async{
                        if(_cameraOpened) {
                          _cameraOpened = false;
                          _onCall(roomId!);
                        } else {
                          _cameraOpened = true;
                          _onCall(roomId!);
                        }
                        setState(() {
                        });
                        },
                      icon: _cameraOpened ? Icon(Icons.videocam) : Icon(Icons.videocam_off),
                      color: Colors.white,
                    ),
                  if(roomId != null)
                    IconButton(
                      onPressed: () async{
                        if(_micOpened) {
                          _micOpened = false;
                          _onCall(roomId!);
                        } else {
                          _micOpened = true;
                          _onCall(roomId!);
                        }
                        setState(() {
                        });
                      },
                      icon: _micOpened ? Icon(Icons.mic) : Icon(Icons.mic_off),
                      color: Colors.white,
                    ),
                  if (!_isBeingCalled && roomId == null)
                    IconButton(
                      onPressed: () async {
                        roomId = await signaling.createRoom(
                          _remoteRenderer,
                          userId!,
                          _cameraOpened,
                          _micOpened,
                          widget.calleeId,
                        );
                        setState(() {
                          _subscribeToCalls();
                        });
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
                  if(roomId != null)
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