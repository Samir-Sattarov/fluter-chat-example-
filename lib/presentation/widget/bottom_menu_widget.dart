import 'package:flutter/material.dart';

class BottomMenuWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function onSend;
  final Function onImage;
  final String hintText;

  const BottomMenuWidget({
    Key? key,
    required this.controller,
    required this.onSend,
    required this.hintText,
    required this.onImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffEEF5FE),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 5,
          right: 20,
          left: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () => onImage(),
              icon: const Icon(Icons.file_copy_outlined),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue.shade800,
              ),
              child: IconButton(
                onPressed: () => onSend(),
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
