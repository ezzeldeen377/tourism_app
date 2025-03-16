// ignore_for_file: camel_case_types, prefer_const_constructors, non_constant_identifier_names

import 'dart:convert';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:new_flutter/core/widgets/contants.dart';
import 'package:http/http.dart' as http;

class chatbot extends StatefulWidget {
  const chatbot({super.key});

  @override
  State<chatbot> createState() => _chatbotState();
}

class _chatbotState extends State<chatbot> {
  ChatUser muself = ChatUser(id: "1", firstName: "Mina");
  ChatUser Bot = ChatUser(id: "2", firstName: "Chat GPT");
  List<ChatMessage> allMasseges = [];
  List<ChatUser>typing=[];

  final ourUrl ="https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyDQF3vh1JSf5gDz8QYRcdySWH9tCbTYmZI";
  final header={"Content-Type": "application/json"};
  getData(ChatMessage m) async {
    typing.add(Bot);
    allMasseges.insert(0, m);
    setState(() {});
      var data={"contents":[{"parts":[{"text":m.text}]}]};
    await http
        .post(Uri.parse(ourUrl),headers: header, body: jsonEncode(data))
        .then((value) {
      if (value.statusCode==200) {
        var result=jsonDecode(value.body);
        print(result["candidates"][0]["content"]["parts"][0]["text"]);
        ChatMessage m1=ChatMessage(
          
          user: Bot,
         createdAt: DateTime.now(),
         text: result["candidates"][0]["content"]["parts"][0]["text"]
         );
         allMasseges.insert(0, m1);
         
      }else{
        print("Error");
      }
    }).catchError((e) {});
    typing.remove(Bot);
    setState(() {
           
         });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: kMainColor,
        elevation: 62,
        title: const Text('Egypt.Chat'),
      ),
      body: DashChat(
        messageOptions:MessageOptions(showTime: true) ,
        typingUsers:typing,
          currentUser: muself,
          onSend: (ChatMessage m) {
            getData(m);
          },
          messages: allMasseges),
    );
  }
}
