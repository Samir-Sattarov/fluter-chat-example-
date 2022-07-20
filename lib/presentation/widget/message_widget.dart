import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final String? messageId;
  final String? sender;
  final String? message;
  final DateTime? createdDate;
  final bool? seen;
  final bool isMe;
  const MessageWidget({
    Key? key,
    required this.messageId,
    required this.sender,
    required this.message,
    required this.createdDate,
    required this.seen,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
            right: 10,
            left: 10,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: isMe ? Colors.brown.shade400 : Colors.brown.shade600,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                message.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
