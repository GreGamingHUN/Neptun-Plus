import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localstorage/localstorage.dart';
import 'package:neptunplus_flutter/messagedetails_screen.dart';
import 'package:neptunplus_flutter/neptun_connection.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

LocalStorage messagesStorage = LocalStorage('messages');

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  void initState() {
    super.initState();
  }

  bool forceRefresh = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: FutureBuilder(
                future: getAllMessages(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Icon(Icons.error_outline);
                  }
                  if (snapshot.hasData) {
                    List? response = snapshot.data;
                    List messagesList = response!;
                    return RefreshIndicator(
                      triggerMode: RefreshIndicatorTriggerMode.onEdge,
                      onRefresh: () async {
                        forceRefresh = true;
                        setState(() {});
                      },
                      child: ListView.builder(
                        itemCount: messagesList.length,
                        itemBuilder: (context, index) {
                          var currentMessage = messagesList[index];
                          return MessageCard(
                              messageAuthor: currentMessage['Name'],
                              messageSubject: currentMessage['Subject'],
                              messageContent: currentMessage['Detail']);
                        },
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ))),
    );
  }

  Future<List?> getAllMessages() async {
    await messagesStorage.ready;
    List? response = await messagesStorage.getItem('messagesList');
    if ((response == null || response.isEmpty || forceRefresh)) {
      try {
        Map tmp = await getMessages();
        //print(tmp['NewMessagesNumber']);
        await messagesStorage.setItem('newMessages', tmp['NewMessagesNumber']);
        await messagesStorage.setItem('messagesList', tmp['MessagesList']);
        response = tmp['MessagesList'];
      } on NeptunErrorMessage catch (e) {
        Fluttertoast.showToast(msg: 'Neptun hiba: ${e.errorMessage}');
      }
    }
    forceRefresh = false;
    return response;
  }
}

class MessageCard extends StatefulWidget {
  final String messageAuthor;
  final String messageSubject;
  final String messageContent;
  const MessageCard(
      {super.key,
      required this.messageAuthor,
      required this.messageSubject,
      required this.messageContent});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  int maxLength = 40;
  String messageContentSubstring(String message) {
    if (message.length <= maxLength) {
      return message;
    }
    return '${message.substring(0, maxLength)}...';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MessagesDetailsWidget(
                  messageAuthor: widget.messageAuthor,
                  messageContent:
                      removeCssCrapFromMessage(widget.messageContent),
                  messageSubject: widget.messageSubject,
                ),
              ));
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.messageSubject,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              Text(messageContentSubstring(
                  removeCssCrapFromMessage(widget.messageContent))),
            ],
          ),
        ),
      ),
    );
  }
}

String removeCssCrapFromMessage(String message) {
  //final String cssPrefix = '\r\n\t\r\n\t\t\r\n\t\t\r\n\t\t\r\n';
  const String cssPostFix = '\t\t\r\n\t\r\n\t\r\n\t\t';
  if (message.contains(cssPostFix)) {
    return message.substring(message.indexOf(cssPostFix) + 10);
  }
  return message;
}
