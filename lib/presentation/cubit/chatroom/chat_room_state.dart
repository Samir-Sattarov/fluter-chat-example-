part of 'chat_room_cubit.dart';

abstract class ChatRoomState {
  const ChatRoomState();
}

class ChatRoomInitial extends ChatRoomState {}

class ChatRoomLoading extends ChatRoomState {}

class ChatRoomLoaded extends ChatRoomState {
  final ChatRoomEntity chatRoom;

  const ChatRoomLoaded({required this.chatRoom});
}

class ChatRoomFailure extends ChatRoomState {
  final String message;

  const ChatRoomFailure(this.message);
}
