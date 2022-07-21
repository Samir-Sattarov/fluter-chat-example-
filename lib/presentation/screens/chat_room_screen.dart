import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/chat_room_entity.dart';
import '../../domain/entity/user_entity.dart';
import '../cubit/message/message_cubit.dart';
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
              await BlocProvider.of<MessageCubit>(context).getRoomMessages(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BlocBuilder<MessageCubit, MessageState>(
              builder: (context, state) {
                if (state is MessageLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (state is MessageLoaded) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.data.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        final message = state.data[index];

                        return MessageWidget(
                          messageId: message.messageId,
                          sender: message.userId,
                          message: message.message,
                          createdDate: message.createdDate,
                          isMe: message.userId == widget.userEntity.uid,
                        );
                      },
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            const SizedBox(height: 10),
            BottomMenuWidget(
              icon: Icons.message,
              controller: controllerMessage,
              hintText: 'Message',
              onSend: () async {
                BlocProvider.of<MessageCubit>(context).sendMessage(
                  userEntity: widget.userEntity,
                  message: controllerMessage.text.trim(),
                  roomId: widget.chatRoomEntity.roomId.toString(),
                  imageUrl: '',
                );
                controllerMessage.clear();
                await BlocProvider.of<MessageCubit>(context).getRoomMessages(
                  roomId: widget.chatRoomEntity.roomId.toString(),
                );
              },
            ),
            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}
