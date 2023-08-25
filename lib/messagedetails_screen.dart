import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class MessagesDetailsWidget extends StatelessWidget {
  final String messageSubject, messageContent, messageAuthor;
  const MessagesDetailsWidget(
      {super.key,
      required this.messageContent,
      required this.messageAuthor,
      required this.messageSubject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(messageAuthor),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  messageSubject,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              Html(
                data: messageContent,
                onLinkTap: (url, attributes, element) {
                  launchUrl(Uri.parse(url!),
                      mode: LaunchMode.externalApplication);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
