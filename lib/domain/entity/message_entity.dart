// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class MessageEntity {
  final String senderId;
  final String message;
  final String messageId;
  final bool isRead;
  final MessageEntity? replyMessage;
  final String? senderName;

  final DateTime createdDate;

  const MessageEntity({
    required this.messageId,
    required this.senderId,
    required this.message,
    required this.createdDate,
    required this.isRead,
    this.senderName,
    this.replyMessage,
  });

  factory MessageEntity.fromJson(json) {
    return MessageEntity(
      senderId: json['senderId'],
      message: json['message'],
      createdDate: DateTime.parse(json['createdAt'].toDate().toString()),
      messageId: json['messageId'],
      replyMessage: json['replayMessage'] != null
          ? MessageEntity.fromJson(json['replyMessage'])
          : null,
      senderName: json['senderName'],
      isRead: json['isRead'],
    );
  }

  get dateTime => DateFormat('dd MMM H:mm').format(createdDate);

  Map<String, dynamic> toJson() {
    return {
      "senderId": senderId,
      "message": message,
      "createdAt": createdDate,
      "messageId": messageId,
      "replyMessage": replyMessage?.toJson(),
      "senderName": senderName,
      "isRead": isRead,
    };
  }
}
