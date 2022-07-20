part of 'sign_up_cubit.dart';

@immutable
abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final UserEntity data;

  SignUpSuccess(this.data);
}

class SignUpError extends SignUpState {
  final String message;

  SignUpError(this.message);
}
