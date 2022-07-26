// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:chat_example/domain/entity/chat_room_entity.dart';
import 'package:chat_example/main.dart';
import 'package:chat_example/presentation/cubit/user/user_cubit.dart';
import 'package:chat_example/presentation/screens/chat_room_screen.dart';
import 'package:chat_example/presentation/widget/text_field_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/user_entity.dart';
import '../widget/user_widget.dart';

class SearchScreen extends StatefulWidget {
  static route(UserEntity entity) => MaterialPageRoute(
        builder: (context) => SearchScreen(
          userEntity: entity,
        ),
      );

  final UserEntity userEntity;
  const SearchScreen({Key? key, required this.userEntity}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController controllerSearch = TextEditingController();

  Future<ChatRoomEntity?> getChatRoomEntity(UserEntity targetUser) async {
    ChatRoomEntity? chatRoomEntity;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('chatrooms')
        .where('participants.${widget.userEntity.uid}', isEqualTo: true)
        .where('participants.${targetUser.uid}', isEqualTo: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final dataFromDoc = snapshot.docs.first.data();
      log('all room already exist $dataFromDoc');

      final ChatRoomEntity existChatroom =
          ChatRoomEntity.fromJson(dataFromDoc as Map<String, dynamic>);

      chatRoomEntity = existChatroom;
      return chatRoomEntity;
    } else {
      log('null');

      ChatRoomEntity newChatRoomEntity = ChatRoomEntity(
        roomId: uuid.v1(),
        participants: {
          widget.userEntity.uid.toString(): true,
          targetUser.uid.toString(): true,
        },
        lastMessage: "",
      );

      await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(newChatRoomEntity.roomId)
          .set(newChatRoomEntity.toMap());

      chatRoomEntity = newChatRoomEntity;

      log('New chatroom crated');
      return chatRoomEntity;
    }
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
        title: const Text(
          'Search',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          TextFormFieldWidget(
            controller: controllerSearch,
            hint: 'Name',
            prefixIcon: Icons.search,
          ),
          BlocBuilder<UserCubit, UserState>(builder: (context, state) {
            if (state is SuccessSearch) {
              return Column(
                children: [
                  ...state.data.map(
                    (data) => UserWidget(
                      title: '${data.name} ${data.surname}',
                      description: data.email!,
                      imageUrl: data.image!,
                      uid: data.uid!,
                      onTap: () async {
                        ChatRoomEntity? roomEntity =
                            await getChatRoomEntity(data);

                        log('navigator $roomEntity');
                        if (roomEntity != null) {
                          Navigator.push(
                            context,
                            ChatRoomScreen.route(
                              targetUser: data,
                              chatRoomEntity: roomEntity,
                              userEntity: widget.userEntity,
                            ),
                          );
                          await BlocProvider.of<UserCubit>(context).getMessages(
                            roomId: roomEntity.roomId.toString(),
                          );
                        }
                      },
                    ),
                  ),
                ],
              );
            }
            if (state is FailedSearch) {
              return const Center(child: Text("Something went wrong"));
            }
            return const SizedBox();
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          BlocProvider.of<UserCubit>(context).searchByName(
            name: controllerSearch.text.trim(),
          );
        },
        child: const Icon(
          Icons.search,
          color: Colors.white,
        ),
      ),
    );
  }

  navigator({
    required UserEntity userEntity,
    required ChatRoomEntity chatRoomEntity,
  }) {
    Navigator.push(
      context,
      ChatRoomScreen.route(
        targetUser: userEntity,
        chatRoomEntity: chatRoomEntity,
        userEntity: widget.userEntity,
      ),
    );
  }
}
