import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'signaling.dart';

class VideoMeetingPage extends StatefulWidget {
  VideoMeetingPage({Key? key}) : super(key: key);

  @override
  _VideoMeetingPageState createState() => _VideoMeetingPageState();
}

class _VideoMeetingPageState extends State<VideoMeetingPage> {
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  TextEditingController textEditingController =
  TextEditingController(text: '');

  bool _cameraOpened = false;

  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();

    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
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
                    icon: Icon(Icons.camera),
                    color: Colors.white,
                  ),
                  IconButton(
                    onPressed: () async {
                      roomId = await signaling.createRoom(_remoteRenderer);
                      textEditingController.text = roomId!;
                      setState(() {});
                    },
                    icon: Icon(Icons.add),
                    color: Colors.white,
                  ),
                  IconButton(
                    onPressed: () {
                      signaling.joinRoom(
                        textEditingController.text.trim(),
                        _remoteRenderer,
                      );
                    },
                    icon: Icon(Icons.join_full),
                    color: Colors.white,
                  ),
                  IconButton(
                    onPressed: () async {
                      signaling.hangUp(_localRenderer);
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.exit_to_app),
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