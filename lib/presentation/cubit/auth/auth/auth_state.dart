part of 'auth_cubit.dart';

abstract class AuthState {}

class UserWasRegistered extends AuthState {}

class UserDontRegistered extends AuthState {}
