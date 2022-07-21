import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/auth/sign_in/sign_in_cubit.dart';
import '../../cubit/user/user_cubit.dart';
import '../../utils/static_images.dart';
import '../../widget/button_widget.dart';
import '../../widget/text_field_widget.dart';
import '../home_screen.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      );

  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SignInCubit, SignInState>(
        listener: (context, state) async {
          if (state is SignInSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              HomeScreen.route(state.data),
              (route) => false,
            );
            BlocProvider.of<UserCubit>(context).getUsers();
          }
        },
        builder: (context, state) {
          if (state is SignInLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SignInError) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () {
                      BlocProvider.of<SignInCubit>(context).reset();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                  Center(
                    child: Image.asset(
                      StaticImages.iFirebaseLogo,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormFieldWidget(
                    hint: 'Email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      }
                      return null;
                    },
                    prefixIcon: Icons.alternate_email,
                    controller: controllerEmail,
                  ),
                  const SizedBox(height: 20),
                  TextFormFieldWidget(
                    hint: 'Password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                    prefixIcon: Icons.lock_outline_rounded,
                    controller: controllerPassword,
                  ),
                  const SizedBox(height: 30),
                  ButtonWidget(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        BlocProvider.of<SignInCubit>(context).signIn(
                          email: controllerEmail.text.trim(),
                          password: controllerPassword.text.trim(),
                        );
                      }
                    },
                    text: 'Sign In',
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          const TextSpan(text: 'Don\'t have account?'),
                          const TextSpan(text: ' '),
                          TextSpan(
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                            text: 'Sign Up',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(context, SignUpScreen.route());
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
