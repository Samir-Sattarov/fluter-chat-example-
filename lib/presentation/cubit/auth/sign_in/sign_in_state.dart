part of 'sign_in_cubit.dart';

abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {
  final UserEntity data;

  SignInSuccess(this.data);
}

class SignInError extends SignInState {
  final String message;

  SignInError(this.message);
}

class ExitError extends SignInState {
  final String message;

  ExitError(this.message);
}
