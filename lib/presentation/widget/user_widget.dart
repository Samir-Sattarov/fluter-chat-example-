import 'dart:developer';

import 'package:chat_example/domain/entity/message_entity.dart';
import 'package:chat_example/presentation/utils/image_preload.dart';
import 'package:flutter/material.dart';

import '../utils/static_images.dart';

class UserWidget extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String description;
  final String uid;
  final MessageEntity? lastMessage;
  final int notReadMessageCount;
  final VoidCallback onTap;

  const UserWidget({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.uid,
    required this.onTap,
    required this.lastMessage,
    required this.notReadMessageCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log('lasMessage is read is ${lastMessage?.isRead}');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: lastMessage != null && lastMessage!.isRead == false
            ? const Color(0xffF5F3EC)
            : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: 60,
                  width: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: imageUrl!.isEmpty && imageUrl == null
                        ? Image.asset(
                            StaticImages.iAvatar,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            imageUrl!,
                            fit: BoxFit.cover,
                          )
                      ..preload(),
                  ),
                ),
                Positioned(
                  left: 45,
                  bottom: 40,
                  child: notReadMessageCount != 0
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(notReadMessageCount.toString()),
                          ),
                        )
                      : const SizedBox(),
                )
              ],
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title),
                      const Text('9 pm'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (lastMessage != null)
                    Text(
                      lastMessage!.message.toString(),
                      maxLines: 3,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    // return GestureDetector(
    //   onTap: onTap,
    //   child: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Container(
    //       decoration: BoxDecoration(
    //         color: Colors.white,
    //         borderRadius: BorderRadius.circular(10),
    //         boxShadow: [
    //           BoxShadow(
    //             blurRadius: 10,
    //             spreadRadius: 1,
    //             color: Colors.grey.withOpacity(0.3),
    //           ),
    //         ],
    //       ),
    //       child: Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Row(
    //           mainAxisSize: MainAxisSize.max,
    //           children: [
    //             ClipRRect(
    //               borderRadius: BorderRadius.circular(10),
    //               child: SizedBox(
    //                 height: 80,
    //                 width: 100,
    //                 child: imageUrl!.isEmpty && imageUrl == null
    //                     ? Image.asset(
    //                         StaticImages.iAvatar,
    //                         fit: BoxFit.cover,
    //                       )
    //                     : Image.network(
    //                         imageUrl!,
    //                         fit: BoxFit.cover,
    //                       )
    //                   ..preload(),
    //               ),
    //             ),
    //             const SizedBox(width: 10),
    //             Column(
    //               mainAxisSize: MainAxisSize.max,
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(title),
    //                 const SizedBox(height: 20),
    //                 Text(description),
    //               ],
    //             ),
    //             const Spacer(),
    //             const Icon(Icons.chevron_right_rounded),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
