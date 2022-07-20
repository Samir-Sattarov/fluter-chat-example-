import 'package:chat_example/presentation/widget/text_field_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/chat_room_entity.dart';
import '../../domain/entity/user_entity.dart';
import '../cubit/user/user_cubit.dart';
import '../widget/bottom_menu_widget.dart';
import '../widget/message_widget.dart';

class ChatRoomScreen extends StatefulWidget {
  static route({
    required UserEntity targetUser,
    required ChatRoomEntity chatRoomEntity,
    required UserEntity userEntity,
  }) =>
      MaterialPageRoute(
        builder: (context) => ChatRoomScreen(
          targetUser: targetUser,
          chatRoomEntity: chatRoomEntity,
          userEntity: userEntity,
        ),
      );

  final UserEntity targetUser;
  final ChatRoomEntity chatRoomEntity;
  final UserEntity userEntity;

  const ChatRoomScreen({
    super.key,
    required this.targetUser,
    required this.chatRoomEntity,
    required this.userEntity,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController controllerMessage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              backgroundImage: NetworkImage(widget.targetUser.image!),
            ),
            const SizedBox(width: 20),
            Text(
              '${widget.targetUser.name} ${widget.targetUser.surname}',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await BlocProvider.of<UserCubit>(context).getMessages(
                roomId: widget.chatRoomEntity.roomId.toString(),
              );
            },
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BlocBuilder<UserCubit, UserState>(
                  bloc: BlocProvider.of<UserCubit>(context),
                  builder: (context, state) {
                    if (state is Loading) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (state is SuccessMessages) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          ...state.messages
                              .map(
                                (message) => MessageWidget(
                                  messageId: message.messageId,
                                  sender: message.sender,
                                  message: message.message,
                                  createdDate: message.createdDate,
                                  seen: message.seen,
                                  isMe: message.sender == widget.userEntity.uid,
                                ),
                              )
                              .toList(),
                          const SizedBox(height: 10)
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),
                BottomMenuWidget(
                  icon: Icons.message,
                  controller: controllerMessage,
                  hintText: 'Message',
                  onSend: () async {
                    BlocProvider.of<UserCubit>(context).sendMessage(
                      userEntity: widget.userEntity,
                      message: controllerMessage.text.trim(),
                      roomId: widget.chatRoomEntity.roomId.toString(),
                    );
                    controllerMessage.clear();
                    await BlocProvider.of<UserCubit>(context).getMessages(
                      roomId: widget.chatRoomEntity.roomId.toString(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
