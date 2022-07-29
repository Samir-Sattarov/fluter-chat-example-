import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entity/user_entity.dart';
import '../cubit/chatroom/chat_room_cubit.dart';
import '../cubit/message/messaging_cubit.dart';
import '../widget/bottom_menu_widget.dart';
import '../widget/message_widget.dart';

class ConnectChatScreen extends StatefulWidget {
  final UserEntity receiver;
  final UserEntity currentUser;

  static route({
    required UserEntity targetUser,
    required UserEntity userEntity,
  }) =>
      MaterialPageRoute(
        builder: (context) => ConnectChatScreen(
          currentUser: userEntity,
          receiver: targetUser,
        ),
      );

  const ConnectChatScreen({
    Key? key,
    required this.receiver,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<ConnectChatScreen> createState() => _ConnectChatScreenState();
}

class _ConnectChatScreenState extends State<ConnectChatScreen> {
  final TextEditingController _controller = TextEditingController();

  MessagingCubit? messagingCubit;
  File? _image;

  @override
  void dispose() {
    _controller.dispose();
    messagingCubit?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
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
                backgroundImage: NetworkImage(widget.receiver.image!),
              ),
              const SizedBox(width: 20),
              Text(
                widget.receiver.fullName,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        body: BlocBuilder<ChatRoomCubit, ChatRoomState>(
          bloc: BlocProvider.of<ChatRoomCubit>(context)
            ..load(targetUser: widget.receiver, entity: widget.currentUser),
          builder: (context, state) {
            if (state is ChatRoomLoaded) {
              return BlocProvider(
                create: (context) {
                  return messagingCubit = MessagingCubit(
                    chatRoom: state.chatRoom,
                    me: widget.currentUser,
                  )..getRoomMessages();
                },
                child: RefreshIndicator(
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
                                    isMe: message.senderId ==
                                        widget.currentUser.uid,
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
                        controller: _controller,
                        hintText: 'Message',
                        onSend: () async {
                          messagingCubit?.sendMessage(
                            currentUser: widget.currentUser,
                            receiver: widget.receiver,
                            message: _controller.text.trim(),
                            replyMessage: null,
                            imageUrl: _image,
                          );
                          _controller.clear();
                          _image = null;

                          messagingCubit?.getRoomMessages();
                        },
                        onImage: () => _pickImage(source: ImageSource.gallery),
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
      ),
    );
  }

  _pickImage({required ImageSource source}) async {
    try {
      final picker = ImagePicker();
      var image = await picker.pickImage(source: source);

      if (image == null) return;

      final imageTemporary = File(image.path);

      setState(() => _image = imageTemporary);
    } on PlatformException catch (error) {
      throw PlatformException(code: error.toString());
    }
  }
}
