part of 'message_cubit.dart';

abstract class MessageState {}

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {}

class MessageSended extends MessageState {}

class MessageEmpty extends MessageState {}

class MessageLoaded extends MessageState {
  final List<MessageEntity> data;

  MessageLoaded(this.data);
}

class MessageError extends MessageState {
  final String message;
  MessageError(this.message);
}
