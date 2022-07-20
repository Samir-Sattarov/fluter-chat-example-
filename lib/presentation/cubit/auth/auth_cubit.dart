import 'dart:developer';

import 'package:chat_example/domain/entity/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/services/auth_service.dart';

part '../auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService service;

  AuthCubit(this.service) : super(AuthInitial());

  exit() async {
    try {
      await service.exit();

      emit(AuthInitial());
    } catch (error) {
      emit(ExitError(error.toString()));
    }
  }

  signIn({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final result = await service.signIn(
        email: email,
        password: password,
      );

      if (result != null) {
        log(result.toString());
        emit(SignInSuccess(result));
        return true;
      } else {
        emit(SignInFailed('Error null'));
        return false;
      }
    } on FirebaseAuthException catch (error) {
      log(error.toString());
      emit(SignInFailed(error.toString()));
    }
  }

  signUp({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final result = await service.signUp(
        email: email,
        password: password,
      );

      if (result != null) {
        emit(SignUpSuccess(result));
      } else {
        emit(SignUpFailed('Error null'));
      }
    } on FirebaseAuthException catch (error) {
      emit(SignUpFailed(error.toString()));
    }
  }

  reset() {
    emit(AuthInitial());
  }
}
