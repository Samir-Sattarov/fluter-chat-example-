import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/services/auth_service.dart';
import '../domain/services/message_services.dart';
import '../domain/services/user_service.dart';
import '../presentation/cubit/auth/auth/auth_cubit.dart';
import '../presentation/cubit/auth/sign_in/sign_in_cubit.dart';
import '../presentation/cubit/auth/sign_up/sign_up_cubit.dart';
import '../presentation/cubit/chatroom/chat_room_cubit.dart';
import '../presentation/cubit/user/user_cubit.dart';
import '../presentation/screens/auth/sign_in_screen.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/storage/secure_storage.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // other

    SecureStorage secureStorage = SecureStorage();
    // Services

    AuthService authService = AuthService();
    UserService userService = UserService();
    MessageService messageService = MessageService();

    // Cubits

    AuthCubit authCubit = AuthCubit(secureStorage, userService);
    UserCubit userCubit = UserCubit(userService);
    SignInCubit signInCubit = SignInCubit(authService, secureStorage);
    SignUpCubit signUpCubit = SignUpCubit(authService);
    ChatRoomCubit chatRoomCubit = ChatRoomCubit(messageService);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => authCubit),
        BlocProvider(create: (BuildContext context) => userCubit),
        BlocProvider(create: (BuildContext context) => signInCubit),
        BlocProvider(create: (BuildContext context) => signUpCubit),
        BlocProvider(create: (BuildContext context) => signUpCubit),
        BlocProvider(create: (BuildContext context) => chatRoomCubit),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is UserWasRegistered) {
              BlocProvider.of<UserCubit>(context).getUsers();
              final user = state.user;
              return HomeScreen(userEntity: user);
            } else if (state is UserDontRegistered) {
              return const SignInScreen();
            } else if (state is AuthLoading) {
              return const Material(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state is AuthError) {
              return Material(
                color: Colors.white,
                child: Center(
                  child: Text('Error ${state.error}'),
                ),
              );
            }
            return const SignInScreen();
          },
        ),
      ),
    );
  }
}
