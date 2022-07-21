import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entity/user_entity.dart';
import '../cubit/user/user_cubit.dart';
import '../utils/static_images.dart';
import '../widget/button_widget.dart';
import '../widget/text_field_widget.dart';
import 'auth/sign_in_screen.dart';

class CompleteProfileScreen extends StatefulWidget {
  static route({
    required UserEntity userEntity,
  }) =>
      MaterialPageRoute(
        builder: (context) => CompleteProfileScreen(
          userEntity: userEntity,
        ),
      );

  final UserEntity userEntity;
  const CompleteProfileScreen({
    Key? key,
    required this.userEntity,
  }) : super(key: key);

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerSurname = TextEditingController();
  File? _image;

  final GlobalKey<FormState> key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          if (state is Success) {
            Navigator.of(context).pushAndRemoveUntil(
              SignInScreen.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is Error) {
            return Center(
              child: Text('Error ${state.message}'),
            );
          }
          return SingleChildScrollView(
            child: Form(
              key: key,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    CupertinoButton(
                      onPressed: () => _pickImage(source: ImageSource.gallery),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        radius: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: _image != null
                              ? Image.file(
                                  _image!,
                                  fit: BoxFit.fill,
                                )
                              : Image.asset(
                                  StaticImages.iAvatar,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldWidget(
                      prefixIcon: Icons.person_outline_rounded,
                      hint: 'Name',
                      controller: controllerName,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldWidget(
                      prefixIcon: Icons.person_outline_rounded,
                      hint: 'Surname',
                      controller: controllerSurname,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ButtonWidget(
                      onPressed: () {
                        if (key.currentState!.validate()) {
                          BlocProvider.of<UserCubit>(context).uploadNewData(
                            userEntity: widget.userEntity,
                            name: controllerName.text.trim(),
                            surname: controllerSurname.text.trim(),
                            image: _image,
                          );
                        }
                      },
                      text: 'Submit',
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future _pickImage({required ImageSource source}) async {
    try {
      final picker = ImagePicker();
      var image = await picker.pickImage(source: source);

      if (image == null) return;

      final imageTemporary = File(image.path);

      setState(() => _image = imageTemporary);
    } on PlatformException catch (error) {
      throw PlatformException(code: error.toString());
    }
  }
}
