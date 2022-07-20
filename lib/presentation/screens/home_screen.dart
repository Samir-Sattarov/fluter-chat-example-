// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/chat_room_entity.dart';
import '../../domain/entity/user_entity.dart';
import '../cubit/auth/sign_in/sign_in_cubit.dart';
import '../cubit/message/message_cubit.dart';
import '../cubit/user/user_cubit.dart';
import '../widget/user_widget.dart';
import 'auth/sign_in_screen.dart';
import 'chat_room_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  static route(UserEntity userEntity) => MaterialPageRoute(
        builder: (context) => HomeScreen(
          userEntity: userEntity,
        ),
      );

  final UserEntity userEntity;
  const HomeScreen({Key? key, required this.userEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await BlocProvider.of<SignInCubit>(context).exit();
              Navigator.push(context, SignInScreen.route());
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: ListView(
        children: [
          BlocBuilder<UserCubit, UserState>(builder: (context, state) {
            if (state is SuccessLoad) {
              return RefreshIndicator(
                onRefresh: () async {
                  BlocProvider.of<UserCubit>(context).getUsers();
                },
                child: Column(
                  children: [
                    ...state.data.map(
                      (data) => userEntity.uid == data.uid
                          ? const SizedBox()
                          : UserWidget(
                              title: '${data.name} ${data.surname}',
                              description: data.email!,
                              imageUrl: data.image!,
                              uid: data.uid!,
                              onTap: () async {
                                ChatRoomEntity? roomEntity =
                                    await BlocProvider.of<MessageCubit>(context)
                                        .getChatRoomEntity(
                                  targetUser: data,
                                  entity: userEntity,
                                );
                                if (roomEntity != null) {
                                  Navigator.push(
                                    context,
                                    ChatRoomScreen.route(
                                      targetUser: data,
                                      chatRoomEntity: roomEntity,
                                      userEntity: userEntity,
                                    ),
                                  );
                                  await BlocProvider.of<MessageCubit>(context)
                                      .getMessages(
                                    roomId: roomEntity.roomId.toString(),
                                  );
                                }
                              },
                            ),
                    ),
                  ],
                ),
              );
            }
            if (state is FailedSearch) {
              return const Center(child: Text("Something went wrong"));
            }
            return const SizedBox();
          }),
          const SizedBox(height: 30),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, SearchScreen.route(userEntity));
        },
        child: const Icon(
          Icons.search,
          color: Colors.white,
        ),
      ),
    );
  }
}
