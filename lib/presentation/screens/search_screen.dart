// ignore_for_file: use_build_context_synchronously

import 'package:chat_example/domain/entity/chat_room_entity.dart';
import 'package:chat_example/presentation/cubit/user/user_cubit.dart';
import 'package:chat_example/presentation/screens/chat_room_screen.dart';
import 'package:chat_example/presentation/widget/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/user_entity.dart';
import '../cubit/message/message_cubit.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextFormFieldWidget(
              controller: controllerSearch,
              hint: 'Name',
              prefixIcon: Icons.search,
            ),
            BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                if (state is SuccessLoad) {
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
                                await BlocProvider.of<MessageCubit>(context)
                                    .getChatRoomEntity(
                                        targetUser: data,
                                        entity: widget.userEntity);
                            if (roomEntity != null) {
                              Navigator.push(
                                context,
                                ChatRoomScreen.route(
                                  targetUser: data,
                                  chatRoomEntity: roomEntity,
                                  userEntity: widget.userEntity,
                                ),
                              );
                              await BlocProvider.of<MessageCubit>(context)
                                  .getRoomMessages(
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
              },
            ),
          ],
        ),
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
