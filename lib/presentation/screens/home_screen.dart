import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/user_entity.dart';
import '../cubit/auth/sign_in/sign_in_cubit.dart';
import '../cubit/chat_list/chat_list_cubit.dart';
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
              Navigator.push(context, SignInScreen.route());
              await BlocProvider.of<SignInCubit>(context).exit();
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<ChatListCubit>(context).load();
        },
        child: BlocBuilder<ChatListCubit, ChatListState>(
          bloc: BlocProvider.of<ChatListCubit>(context)..load(),
          builder: (context, state) {
            if (state is ChatListLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is ChatListLoaded) {
              return ListView(
                children: [
                  ...state.chats.map(
                    (data) => UserWidget(
                      title: '${data.user.name} ${data.user.surname}',
                      description: data.user.email!,
                      imageUrl: data.user.image!,
                      uid: data.user.uid,
                      onTap: () async {
                        Navigator.push(
                          context,
                          ConnectChatScreen.route(
                            userEntity: userEntity,
                            targetUser: data.user,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              );
            }
            if (state is ChatListFailure) {
              return Center(
                child: Text(state.message),
              );
            }
            return Text(
              state.toString(),
            );
          },
        ),
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
