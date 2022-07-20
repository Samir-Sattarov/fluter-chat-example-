import 'package:chat_example/presentation/widget/text_field_widget.dart';
import 'package:flutter/material.dart';

class BottomMenuWidget extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final Function onSend;
  final String hintText;

  const BottomMenuWidget({
    Key? key,
    required this.controller,
    required this.icon,
    required this.onSend,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: TextFormFieldWidget(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            prefixIcon: icon,
            hint: hintText,
            controller: controller,
          ),
        ),
        IconButton(
          onPressed: () => onSend(),
          icon: const Icon(Icons.send),
        ),
      ],
    );
  }
}
