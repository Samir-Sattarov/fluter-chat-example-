import 'package:cloud_firestore/cloud_firestore.dart';

class MessageEntity {
  final String? message;
  final DateTime? createdDate;
  final String? userId;
  final String? imageUrl;
  final String? messageId;

  MessageEntity({
    required this.message,
    required this.createdDate,
    required this.userId,
    required this.messageId,
    required this.imageUrl,
  });

  factory MessageEntity.fromJson(Map<String, dynamic> json) {
    return MessageEntity(
      message: json['message'],
      createdDate: (json['createdDate'] as Timestamp).toDate(),
      userId: json['userId'],
      imageUrl: json['imageUrl'],
      messageId: json['messageId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'createdDate': createdDate,
      'userId': userId,
      'imageUrl': imageUrl,
      'messageId': messageId,
    };
  }
}
