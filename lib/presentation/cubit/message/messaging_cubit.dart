import 'dart:async';
import 'dart:developer';

import 'package:chat_example/domain/entity/user_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entity/chat_room_entity.dart';
import '../../../domain/entity/message_entity.dart';
import '../../../domain/services/message_services.dart';

part 'messaging_state.dart';

class MessagingCubit extends Cubit<MessagingState> {
  final MessageService service = MessageService();
  final UserEntity me;
  ChatRoomEntity chatRoom;

  late StreamSubscription messagesStream;

  MessagingCubit({
    required this.chatRoom,
    required this.me,
  }) : super(MessagingInitial()) {
    messagesStream =
        service.getMessages(roomId: chatRoom.roomId).listen((snapshot) {
      List<MessageEntity> dataList = [];

      if (List.of(snapshot.docs).isNotEmpty) {
        for (var doc in snapshot.docs) {
          final data = doc.data();

          final message = MessageEntity.fromJson(data);
          dataList.add(message);
        }
        emit(MessageLoaded(dataList));
      } else {
        emit(MessagingEmpty());
      }
    });
  }

  Future<void> sendMessage({
    required UserEntity userEntity,
    required String? message,
    MessageEntity? replyMessage,
  }) async {
    try {
      final result = await service.sendMessage(
        userEntity: userEntity,
        message: message,
        roomId: chatRoom.roomId,
        replayMessage: replyMessage,
      );

      if (result == true) {
        log('message send');
      } else {
        log('message not send');
      }
    } catch (error) {
      log('error $error');
      emit(MessagingError(error.toString()));
    }
  }

  Future<void> getRoomMessages() async {
    try {
      log(me.name.toString());
      service.updateAllMessageToRead(
        roomId: chatRoom.roomId,
        me: me,
      );
    } catch (error) {
      log('error $error');

      emit(MessagingError(error.toString()));
    }
  }

  @override
  Future<void> close() {
    messagesStream.cancel();
    return super.close();
  }
}
