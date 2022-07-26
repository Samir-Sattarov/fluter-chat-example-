part of 'chat_list_cubit.dart';

abstract class ChatListState {
  const ChatListState();
}

class ChatListInitial extends ChatListState {}

class ChatListLoading extends ChatListState {}

class ChatListLoaded extends ChatListState {
  final List<ChatItem> chats;

  const ChatListLoaded({required this.chats});
}

class ChatListFailure extends ChatListState {
  final String message;

  const ChatListFailure({required this.message});
}
