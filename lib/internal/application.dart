import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/services/auth_service.dart';
import '../domain/services/user_service.dart';
import '../presentation/cubit/auth/auth_cubit.dart';
import '../presentation/cubit/user/user_cubit.dart';
import '../presentation/screens/auth/sign_in_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Services

    AuthService authService = AuthService();
    UserService userService = UserService();

    // Cubits

    AuthCubit authCubit = AuthCubit(authService);
    UserCubit userCubit = UserCubit(userService);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => authCubit),
        BlocProvider(create: (BuildContext context) => userCubit),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: const SignInScreen(),
      ),
    );
  }
}
