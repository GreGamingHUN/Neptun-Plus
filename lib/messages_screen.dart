import 'dart:math';

import 'package:flutter/material.dart';
import 'package:neptunplus_app/main.dart';
import 'api_calls.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List messageList = [];
  Future<dynamic> getMessageData() async {
    messageList = await apiCalls.getMessages();
    return messageList;
  }

  @override
  Widget build(BuildContext context) {
    if (storage.getItem('messages') != null) {
      messageList = storage.getItem('messages');
      return ListView.builder(
        itemCount: messageList.length,
        itemBuilder: (context, index) {
          return MessageCard(
              messageAuthor: messageList[index]['Name'],
              messageContent: messageList[index]['Subject']);
        },
      );
    }
    return FutureBuilder(
      future: getMessageData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          storage.setItem('messages', messageList);
          return ListView.builder(
            itemCount: messageList.length,
            itemBuilder: (context, index) {
              return MessageCard(
                  messageAuthor: messageList[index]['Name'],
                  messageContent: messageList[index]['Subject']);
            },
          );
        } else if (snapshot.hasError) {
          return const Text('Valami nem jó');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class MessageCard extends StatefulWidget {
  final String messageAuthor;
  final String messageContent;

  MessageCard({required this.messageAuthor, required this.messageContent})
      : super(key: ValueKey(messageAuthor));

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: const Color.fromARGB(255, 187, 221, 238)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.messageAuthor,
                style: const TextStyle(fontSize: 18),
              ),
              Text(widget.messageContent
                  .substring(0, min(widget.messageContent.length, 45)))
            ],
          ),
        ),
      ),
    );
  }
}
