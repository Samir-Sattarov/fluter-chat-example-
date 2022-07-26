import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/user_entity.dart';
import '../cubit/user/user_cubit.dart';
import '../widget/text_field_widget.dart';
import '../widget/user_widget.dart';
import 'chat_room_screen.dart';

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
                          uid: data.uid,
                          onTap: () async {
                            Navigator.push(
                              context,
                              ConnectChatScreen.route(
                                userEntity: widget.userEntity,
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
}
