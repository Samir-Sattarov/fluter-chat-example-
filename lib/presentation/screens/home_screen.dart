import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/user_entity.dart';
import '../cubit/auth/sign_in/sign_in_cubit.dart';
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
          BlocProvider.of<UserCubit>(context).getUsers();
        },
        child: ListView(
          children: [
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
                            Navigator.push(
                              context,
                              ConnectChatScreen.route(
                                userEntity: userEntity,
                                targetUser: data,
                              ),
                            );
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
            const SizedBox(height: 30),
          ],
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
