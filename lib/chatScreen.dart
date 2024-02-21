import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<String> _messages = []; // List to hold chat messages
  final TextEditingController _textController =
      TextEditingController(); // Controller for text input

  // Function to handle sending a message
  void _handleSendMessage(String message) {
    setState(() {
      _messages.add(message); // Add the message to the list
      _textController.clear(); // Clear the text input field
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
      ),
      body: Column(
        children: <Widget>[
          // Widget to display messages
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]), // Display the message
                  // You can add more info like message sender, timestamp, etc.
                );
              },
            ),
          ),
          // Widget for input field and send button
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    String message = _textController.text.trim();
                    if (message.isNotEmpty) {
                      _handleSendMessage(message); // Send the message
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
