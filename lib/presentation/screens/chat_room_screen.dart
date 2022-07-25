import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/user_entity.dart';
import '../cubit/chatroom/chat_room_cubit.dart';
import '../cubit/message/messaging_cubit.dart';
import '../widget/bottom_menu_widget.dart';
import '../widget/message_widget.dart';

class ConnectChatScreen extends StatefulWidget {
  final UserEntity targetUser;
  final UserEntity userEntity;

  static route({
    required UserEntity targetUser,
    required UserEntity userEntity,
  }) =>
      MaterialPageRoute(
        builder: (context) => ConnectChatScreen(
          userEntity: userEntity,
          targetUser: targetUser,
        ),
      );

  const ConnectChatScreen({
    Key? key,
    required this.targetUser,
    required this.userEntity,
  }) : super(key: key);

  @override
  State<ConnectChatScreen> createState() => _ConnectChatScreenState();
}

class _ConnectChatScreenState extends State<ConnectChatScreen> {
  final TextEditingController _controller = TextEditingController();

  MessagingCubit? messagingCubit;

  @override
  void dispose() {
    _controller.dispose();
    messagingCubit?.close();
    super.dispose();
  }

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
      ),
      body: BlocBuilder<ChatRoomCubit, ChatRoomState>(
        bloc: BlocProvider.of<ChatRoomCubit>(context)
          ..load(targetUser: widget.targetUser, entity: widget.userEntity),
        builder: (context, state) {
          if (state is ChatRoomLoaded) {
            return BlocProvider(
              create: (context) {
                return messagingCubit = MessagingCubit(
                  chatRoom: state.chatRoom,
                  me: widget.userEntity,
                )..getRoomMessages();
              },
              child: RefreshIndicator(
                color: Colors.green.shade200,
                onRefresh: () async {
                  messagingCubit?.getRoomMessages();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BlocBuilder<MessagingCubit, MessagingState>(
                      bloc: messagingCubit,
                      builder: (context, state) {
                        if (state is MessagingLoading) {
                          return const Expanded(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (state is MessageLoaded) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: state.message.length,
                              padding: const EdgeInsets.all(24),
                              reverse: true,
                              itemBuilder: (context, index) {
                                final message = state.message[index];
                                return MessageWidget(
                                  onTap: () {},
                                  isMe:
                                      message.senderId == widget.userEntity.uid,
                                  onLongPress: () {},
                                  message: message,
                                );
                              },
                            ),
                          );
                        }
                        if (state is MessagingError) {
                          return Text('Error ${state.error}');
                        }
                        return const SizedBox();
                      },
                    ),
                    const SizedBox(height: 10),
                    BottomMenuWidget(
                      icon: Icons.message,
                      controller: _controller,
                      hintText: 'Message',
                      onSend: () async {
                        messagingCubit?.sendMessage(
                          userEntity: widget.userEntity,
                          message: _controller.text.trim(),
                          replyMessage: null,
                        );
                        _controller.clear();

                        messagingCubit?.getRoomMessages();
                      },
                      onImage: () {},
                    ),
                    const SizedBox(height: 10)
                  ],
                ),
              ),
            );
          }

          if (state is ChatRoomLoading) {
            return const Center(child: Text('Loading chatroom ....'));
          }

          if (state is ChatRoomFailure) {
            return Center(child: Text('chatroom failed ${state.message}'));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
