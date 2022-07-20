import 'package:chat_example/presentation/utils/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/auth/sign_up/sign_up_cubit.dart';
import '../../utils/form_validator.dart';
import '../../utils/static_images.dart';
import '../../widget/back_elevation_button_widget.dart';
import '../../widget/button_widget.dart';
import '../../widget/text_field_widget.dart';
import '../complete_profile_screen.dart';

class SignUpScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      );

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final TextEditingController controllerConfirmPassword =
      TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) async {
          if (state is SignUpSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              CompleteProfileScreen.route(
                userEntity: state.data,
              ),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is SignUpLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is SignUpError) {
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
                      BlocProvider.of<SignUpCubit>(context).reset();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }
          return SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.15),
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
                            'Sign Up',
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
                          validator: FormValidator.validateEmail,
                          prefixIcon: Icons.alternate_email,
                          controller: controllerEmail,
                        ),
                        const SizedBox(height: 20),
                        TextFormFieldWidget(
                          hint: 'Password',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          prefixIcon: Icons.lock_outline_rounded,
                          controller: controllerPassword,
                        ),
                        const SizedBox(height: 30),
                        ButtonWidget(
                          onPressed: () {
                            BlocProvider.of<SignUpCubit>(context).signUp(
                              email: controllerEmail.text.trim(),
                              password: controllerPassword.text.trim(),
                            );
                          },
                          text: 'Sign Up',
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10, top: 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: BackElevationButtonWidget(),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
