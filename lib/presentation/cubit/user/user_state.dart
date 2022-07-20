part of 'user_cubit.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class Success extends UserState {}

class Loading extends UserState {}

class Failed extends UserState {}

class SuccessMessages extends UserState {
  final List<MessageEntity> messages;

  SuccessMessages(this.messages);
}

class FailedMessages extends UserState {}

class SuccessSearch extends UserState {
  final List<UserEntity> data;

  SuccessSearch({required this.data});
}

class FailedSearch extends UserState {}

class Error extends UserState {
  final String message;

  Error(this.message);
}
