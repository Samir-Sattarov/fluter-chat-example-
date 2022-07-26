part of 'last_message_cubit.dart';

abstract class LastMessageState {
  const LastMessageState();
}

class LastMessageInitial extends LastMessageState {}

class LastMessageLoading extends LastMessageState {}

class LastMessageLoaded extends LastMessageState {
  final ChatRoomEntity chatRoom;
  final int notReadMessageCount;

  const LastMessageLoaded({
    required this.chatRoom,
    required this.notReadMessageCount,
  });
}

class LastMessageEmpty extends LastMessageState {}

class LastMessageFailure extends LastMessageState {
  final String message;

  const LastMessageFailure({required this.message});
}
