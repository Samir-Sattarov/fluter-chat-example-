import 'dart:async';

import 'package:chat_example/domain/entity/user_entity.dart';
import 'package:chat_example/domain/services/message_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/chat_room_entity.dart';

part 'last_message_state.dart';

class LastMessageCubit extends Cubit<LastMessageState> {
  final MessageService service;
  final UserEntity user;
  final UserEntity sender;
  late StreamSubscription streamSubscription;

  LastMessageCubit({
    required this.service,
    required this.user,
    required this.sender,
  }) : super(LastMessageInitial()) {
    streamSubscription = service
        .getLastMessage(senderId: user.uid, userId: sender.uid)
        .listen((snapshot) async {
      int lastMessageCount = 1000;

      if (List.of(snapshot.docs).isNotEmpty) {
        late ChatRoomEntity room;

        for (var doc in snapshot.docs) {
          final data = doc.data();

          room = ChatRoomEntity.fromJson(data);
        }

        lastMessageCount =
            await service.getNotReadMessageForChatRoomEntityCount(
          room,
          user,
        );
        print(
            "BUILD LAST MESSAGE | last message: ${room.lastMessage?.message} | count:$lastMessageCount");
        emit(LastMessageLoaded(
          notReadMessageCount: lastMessageCount,
          chatRoom: room,
        ));
      } else {
        emit(LastMessageEmpty());
      }
    });
  }

  @override
  Future<void> close() {
    streamSubscription.cancel();
    print("LastMessageCubit closed!");
    return super.close();
  }
}
