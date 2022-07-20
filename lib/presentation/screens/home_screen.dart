import 'package:chat_example/domain/entity/user_entity.dart';
import 'package:chat_example/presentation/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth/auth_cubit.dart';
import '../widget/button_widget.dart';

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
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Home Screen'),
          const SizedBox(height: 30),
          ButtonWidget(
            onPressed: () {
              Navigator.pop(context);
              BlocProvider.of<AuthCubit>(context).exit();
            },
            text: 'Exit',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, SearchScreen.route(userEntity));
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}
