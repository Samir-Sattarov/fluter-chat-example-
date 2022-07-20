import 'package:cloud_firestore/cloud_firestore.dart';

class MessageEntity {
  final String? messageId;
  final String? sender;
  final String? message;
  final DateTime? createdDate;
  final bool? seen;

  MessageEntity(
      {required this.sender,
      required this.messageId,
      required this.message,
      required this.createdDate,
      required this.seen});

  factory MessageEntity.fromJson(Map<String, dynamic> json) {
    return MessageEntity(
      sender: json['sender'],
      message: json['message'],
      createdDate: (json['createdDate'] as Timestamp).toDate(),
      seen: json['seen'],
      messageId: json['messageId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'message': message,
      'createdDate': createdDate,
      'seen': seen,
      'messageId': messageId,
    };
  }
}
