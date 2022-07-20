import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entity/user_entity.dart';
import '../../../../domain/services/auth_service.dart';
import '../../../storage/secure_storage.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final AuthService service;
  final SecureStorage storage;
  SignInCubit(this.service, this.storage) : super(SignInInitial());

  exit() async {
    try {
      await service.exit();

      emit(SignInInitial());
      const key = 'email';
      storage.delete(key: key);
    } catch (error) {
      emit(ExitError(error.toString()));
    }
  }

  signIn({
    required String email,
    required String password,
  }) async {
    emit(SignInLoading());
    try {
      final data = await service.signIn(
        email: email,
        password: password,
      );

      if (data != null) {
        emit(SignInSuccess(data));
        return true;
      } else {
        emit(SignInError('Error null'));
        return false;
      }
    } on FirebaseAuthException catch (error) {
      log(error.toString());
      emit(SignInError(error.toString()));
    }
  }

  reset() {
    emit(SignInInitial());
  }
}
