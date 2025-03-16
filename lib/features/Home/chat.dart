import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:new_flutter/core/widgets/contants.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool isTyping = false;

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final message = _controller.text;
    _controller.clear();

    setState(() {
      _messages.add({'sender': 'user', 'text': message});
      isTyping = true; // Set typing to true when sending a message
    });

    // Simulate typing delay
    await Future.delayed(const Duration(seconds: 2));

    try {
      final http.Response response = await http.get(
        Uri.parse('http://10.0.2.2:5000/get?msg=$message'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _messages.add({'sender': 'bot', 'text': response.body});
          isTyping = false; // Set typing to false when response is received
        });
      } else {
        setState(() {
          _messages.add({'sender': 'bot', 'text': 'Error: Could not fetch answer.'});
          isTyping = false; // Set typing to false on error
        });
      }
    } on Exception catch (e) {
      setState(() {
        _messages.add({'sender': 'bot', 'text': 'Error: Could not fetch answer.'});
        isTyping = false; // Set typing to false on exception
      });
    }

    _scrollToBottom();
  }

  @override
  void initState() {
    super.initState();
    _messages.add({'sender': 'bot', 'text': "Hi,Welcome to Chatbot,How Can i help You?"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: kMainColor,
        elevation: 62,
        title: const Text('ChatBot'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length + (isTyping ? 1 : 0), // Adjust itemCount for typing indicator
              itemBuilder: (context, index) {
                if (index == _messages.length && isTyping) {
                  // Show typing indicator
                  return Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(8),
                      child: const Row(
                        children: [
                          Text('•••', style: TextStyle(fontSize: 24)),
                          SizedBox(width: 8),
                          Text(
                            'Chat Bot is typing...',
                            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                final message = _messages[index];
                return Align(
                  alignment: message['sender'] == 'bot'
                      ? AlignmentDirectional.centerStart
                      : AlignmentDirectional.centerEnd,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: message['sender'] == 'user'
                          ? const Color.fromARGB(255, 255, 187, 0)
                          : Color.fromARGB(255, 226, 197, 118),
                    ),
                    child: Text(
                      message['text']!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      labelText: 'Send a message',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
