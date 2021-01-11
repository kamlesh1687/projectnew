import 'package:cloud_firestore/cloud_firestore.dart';

Message msg;

class Message {
  final String imagemessageUrl;
  final String textMessage;
  final String postlocation;
  final String senderId;
  final bool isRead;
  var messageTime;

  Message({
    this.imagemessageUrl,
    this.messageTime,
    this.postlocation,
    this.isRead,
    this.senderId,
    this.textMessage,
  });

  factory Message.fromDocument(DocumentSnapshot doc) {
    return Message();
  }
}
