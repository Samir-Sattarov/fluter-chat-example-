import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../domain/entity/message_entity.dart';

class MessageWidget extends StatelessWidget {
  final MessageEntity message;
  final VoidCallback onLongPress;
  final VoidCallback onTap;

  final bool isMe;
  const MessageWidget({
    Key? key,
    required this.isMe,
    required this.onLongPress,
    required this.onTap,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      onLongPress: () => onLongPress(),
      child: Padding(
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
                borderRadius: BorderRadius.circular(10),
                color: isMe ? Colors.brown.shade400 : Colors.brown.shade600,
              ),
              child: Padding(
                padding: message.message != null && message.message!.isNotEmpty
                    ? const EdgeInsets.symmetric(horizontal: 10, vertical: 10)
                    : EdgeInsets.zero,
                child: Column(
                  children: [
                    if (message.message != null)
                      Text(
                        message.message.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    if (message.image != null)
                      CachedNetworkImage(
                        imageUrl: message.image!,
                        errorWidget: (context, url, error) =>
                            const Text("error"),
                        imageBuilder: (context, imageProvider) => ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            image: imageProvider,
                            fit: BoxFit.cover,
                            width: 200,
                            height: 200,
                          ),
                        ),
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(
                          backgroundColor: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
