// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class MessageEntity {
  final String senderId;
  final String? message;
  final String? receiverId;
  final String messageId;
  final bool isRead;
  final MessageEntity? replyMessage;
  final String? senderName;
  final DateTime createdDate;
  final String messageType;
  final String? image;

  const MessageEntity({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.createdDate,
    required this.isRead,
    required this.messageType,
    this.image,
    this.senderName,
    this.replyMessage,
  });

  factory MessageEntity.fromJson(json) {
    return MessageEntity(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      message: json['message'],
      createdDate: DateTime.parse(json['createdAt'].toDate().toString()),
      messageId: json['messageId'],
      replyMessage: json['replayMessage'] != null
          ? MessageEntity.fromJson(json['replyMessage'])
          : null,
      senderName: json['senderName'],
      isRead: json['isRead'],
      messageType: json['messageType'],
      image: json['image'],
    );
  }

  get dateTime => DateFormat('dd MMM H:mm').format(createdDate);

  Map<String, dynamic> toJson() {
    return {
      "senderId": senderId,
      "receiverId": receiverId,
      "message": message,
      "createdAt": createdDate,
      "messageId": messageId,
      "replyMessage": replyMessage?.toJson(),
      "senderName": senderName,
      "isRead": isRead,
      "messageType": messageType,
      "image": image,
    };
  }
}
