import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../DashboardScreen.dart';
import '../loginMainScreenFiles/custom_route.dart';
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
  bool _isCheckingNow = true;

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

    _checkIfBeingCalled().then((_) {
      setState(() {
        _isCheckingNow = false;
      });
    });

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
        .listen((snapshot) async {
      if (snapshot.exists) {
        if(_isBeingCalled){
          _cameraOpened = snapshot.data()?['callerCamera'];
          _micOpened = snapshot.data()?['callerMic'];
        }
        else{
          _calleeCameraOpened = snapshot.data()?['calleeCamera'];
          _calleeMicOpened = snapshot.data()?['calleeMic'];
        }
        _onCall(roomId!);
        if(!(snapshot.data()?['isActive'])) {
          await FirebaseFirestore.instance.collection('currentCalls').doc(roomId).delete();
          if(!_isBeingCalled){
            signaling.hangUp(_localRenderer);
            dispose();
            Navigator.of(context).pushReplacement(
              FadePageRoute(
                builder: (context) => const DashboardScreen(),
              ),
            );
          }
          else{
            dispose();
            signaling.hangUp(_localRenderer);
            Navigator.pop(context);
          }
        }
        setState(() {
          });
      }
      else{
        if(_isBeingCalled){
          signaling.hangUp(_localRenderer);
          dispose();
          Navigator.of(context).pushReplacement(
            FadePageRoute(
              builder: (context) => const DashboardScreen(),
            ),
          );
        }
      }
    });
  }

  void _onCall(String roomId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    if(_isBeingCalled) {
      await db.collection('currentCalls').doc(roomId).update({
        'calleeCamera': _calleeCameraOpened,
        'calleeMic': _calleeMicOpened,
      });
    }
    else{
      await db.collection('currentCalls').doc(roomId).update({
        'callerCamera': _cameraOpened,
        'callerMic': _micOpened,
      });
    }
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
    await Future.delayed(Duration(seconds: 1));
    if (userId != null) {
      String? roomIdLocal = await isBeingCalled(userId!);
      if (roomIdLocal != null) {
        signaling.openUserMedia(_localRenderer, _remoteRenderer);
        await Future.delayed(Duration(seconds: 1));
        await signaling.joinRoom(roomIdLocal, _remoteRenderer);
        setState(() {
          _isBeingCalled = true;
          roomId = roomIdLocal;
          _subscribeToCalls();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if(_isBeingCalled || roomId != null)
            return false;
          else {
            signaling.hangUp(_localRenderer);
            dispose();
            return true;
          }
        },
        child: _isCheckingNow ?
        Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          ),
        ) :
        Scaffold(
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
                          child: (_isBeingCalled ? _calleeCameraOpened : _cameraOpened)
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
                          child: (_isBeingCalled ? _cameraOpened : _calleeCameraOpened)
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
                      // CAMERA BUTTON
                      if(roomId != null)
                        IconButton(
                          onPressed: () async{
                            if(_isBeingCalled){
                              if (_calleeCameraOpened) {
                                _calleeCameraOpened = false;
                                _onCall(roomId!);
                              } else {
                                _calleeCameraOpened = true;
                                _onCall(roomId!);
                              }
                            }
                            else{
                              if (_cameraOpened) {
                                _cameraOpened = false;
                                _onCall(roomId!);
                              } else {
                                _cameraOpened = true;
                                _onCall(roomId!);
                              }
                            }
                            setState(() {
                            });
                          },
                          icon: (_isBeingCalled ? _calleeCameraOpened : _cameraOpened) ? Icon(Icons.videocam) : Icon(Icons.videocam_off),
                          color: Colors.white,
                        ),
                      // MIC BUTTON
                      if(roomId != null)
                        IconButton(
                          onPressed: () async{
                            if(_isBeingCalled) {
                              if (_calleeMicOpened) {
                                _calleeMicOpened = false;
                                _onCall(roomId!);
                              } else {
                                _calleeMicOpened = true;
                                _onCall(roomId!);
                              }
                            }
                            else{
                              if (_micOpened) {
                                _micOpened = false;
                                _onCall(roomId!);
                              } else {
                                _micOpened = true;
                                _onCall(roomId!);
                              }
                            }
                            setState(() {
                            });
                          },
                          icon: (_isBeingCalled ? _calleeMicOpened : _micOpened) ? Icon(Icons.mic) : Icon(Icons.mic_off),
                          color: Colors.white,
                        ),
                      // CALL BUTTON
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
                      // CREATE ROOM BUTTON (NO USE)
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

                      // HANG UP BUTTON
                      if(roomId != null)
                        IconButton(
                          onPressed: () async {
                            signaling.hangUp(_localRenderer);
                            FirebaseFirestore db = FirebaseFirestore.instance;
                            await db.collection('currentCalls').doc(roomId).update({
                              'isActive' : false,
                            });
                            if(!_isBeingCalled) {
                                    await FirebaseFirestore.instance
                                        .collection('currentCalls')
                                        .doc(roomId)
                                        .delete();
                                    signaling.hangUp(_localRenderer);
                                    dispose();
                                    Navigator.of(context).pushReplacement(
                                      FadePageRoute(
                                        builder: (context) =>
                                            const DashboardScreen(),
                                      ),
                                    );
                                  }
                            else{
                              dispose();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => DashboardScreen()),
                              );
                            }
                                  setState(() async {
                            });
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
        ));
  }
}