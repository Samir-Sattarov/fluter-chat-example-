import 'dart:developer';

import 'package:chat_example/domain/entity/user_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/services/message_services.dart';
import '../../../domain/services/user_service.dart';
import '../last_message/last_message_cubit.dart';

part 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  final UserService userService;
  final MessageService messageService;
  final UserEntity me;

  List<ChatItem> chatItems = [];

  ChatListCubit({
    required this.userService,
    required this.messageService,
    required this.me,
  }) : super(ChatListInitial());

  Future<void> load() async {
    emit(ChatListLoading());

    try {
      List<UserEntity> users = await userService.getUsers(
        currentUserId: me.uid,
      );

      log('users is $users');

      chatItems = users.map((user) {
        final lastMessageCubit = LastMessageCubit(
          user: user,
          sender: me,
          service: messageService,
        );

        ChatItem chatItem = ChatItem(
          user: user,
          lastMessageCubit: lastMessageCubit,
        );

        lastMessageCubit.stream.listen((LastMessageState state) {
          if (state is LastMessageLoaded) {
            if (state.chatRoom.lastMessage != null) {
              final sort = state
                  .chatRoom.lastMessage!.createdDate.millisecondsSinceEpoch;
              chatItem.sort = sort;
              print(
                "CHANGED sort for: ${chatItem.user.fullName} changedSort:${chatItem.sort}",
              );
            }
            sort();
          }
        });

        return chatItem;
      }).toList();

      emit(ChatListLoaded(chats: chatItems));
    } catch (e) {
      log(e.toString());
      emit(ChatListFailure(message: e.toString()));
    }
  }

  void sort() {
    chatItems.sort((a, b) {
      return b.sort.compareTo(a.sort);
    });

    chatItems.forEach((element) {
      print("name: ${element.user.fullName} sort: ${element.sort}");
    });

    emit(ChatListLoaded(chats: chatItems));
  }
}

class ChatItem {
  final UserEntity user;
  final LastMessageCubit lastMessageCubit;
  int sort;

  ChatItem({
    required this.user,
    required this.lastMessageCubit,
    this.sort = 0,
  });
}
