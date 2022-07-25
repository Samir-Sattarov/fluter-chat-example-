part of 'messaging_cubit.dart';

abstract class MessagingState {
  const MessagingState();
}

class MessagingInitial extends MessagingState {}

class MessagingLoading extends MessagingState {}

class MessagingEmpty extends MessagingState {
  List<Object> get props => [];
}

class MessageLoaded extends MessagingState {
  final List<MessageEntity> message;

  const MessageLoaded(this.message);
}

class LastMessageLoaded extends MessagingState {
  final ChatRoomEntity message;

  const LastMessageLoaded(this.message);
}

class MessagingError extends MessagingState {
  final String error;

  const MessagingError(this.error);
}
