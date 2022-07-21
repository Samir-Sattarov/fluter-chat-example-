part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class UserWasRegistered extends AuthState {
  final UserEntity user;

  UserWasRegistered(this.user);
}

class UserDontRegistered extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String error;

  AuthError(this.error);
}
