import 'package:chat_example/presentation/utils/image_preload.dart';
import 'package:flutter/material.dart';

import '../utils/static_images.dart';

class UserWidget extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String description;
  final String uid;
  final VoidCallback onTap;

  const UserWidget({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.uid,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                spreadRadius: 1,
                color: Colors.grey.withOpacity(0.3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 80,
                    width: 100,
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
                const SizedBox(width: 10),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title),
                    const SizedBox(height: 20),
                    Text(description),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
