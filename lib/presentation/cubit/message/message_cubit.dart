import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/chat_room_entity.dart';
import '../../../domain/entity/message_entity.dart';
import '../../../domain/entity/user_entity.dart';
import '../../../domain/services/message_services.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final MessageService service;

  MessageCubit(this.service) : super(MessageInitial());

  sendMessage({
    required UserEntity userEntity,
    required String? message,
    required String roomId,
    required String? imageUrl,
  }) async {
    try {
      final result = await service.sendMessage(
        userEntity: userEntity,
        message: message,
        roomId: roomId,
        imageUrl: imageUrl,
      );

      if (result == true) {
        log('message send');
      } else {
        log('message not send');
      }
    } catch (error) {
      log('error $error');
      emit(MessageError(error.toString()));
    }
  }

  Future<ChatRoomEntity?> getChatRoomEntity({
    required UserEntity targetUser,
    required UserEntity entity,
  }) async {
    try {
      final result = await service.getChatRoomEntity(
        targetUser: targetUser,
        entity: entity,
      );

      return result;
    } catch (error) {
      log('error $error');
      emit(MessageError(error.toString()));
    }
    return null;
  }

  //getMessages() async {
  //     List<MessageEntity> messageList = [];
  //     messageList.clear();
  //
  //     emit(MessageLoading());
  //
  //     try {
  //       final messages = service.getMessages();
  //
  //       messages.listen((snapshot) {
  //         log('snapshot: ${snapshot.docs}');
  //         if (List.of(snapshot.docs).isNotEmpty) {
  //           messageList.clear();
  //
  //           for (var doc in snapshot.docs) {
  //             log('doc: ${doc.data()}');
  //             final message = MessageEntity(
  //               message: doc.data()['text'],
  //               createdAt: (doc.data()['createdAt'] as Timestamp).toDate(),
  //               userId: doc.data()['userId'],
  //               imageUrl: '',
  //             );
  //             messageList.add(message);
  //
  //             emit(MessageLoaded(messageList));
  //           }
  //         } else {
  //           emit(MessageEmpty());
  //         }
  //       });
  //     } catch (error) {
  //       emit(MessageError(error.toString()));
  //       return null;
  //     }
  //   }
  getMessages({required String roomId}) async {
    emit(MessageLoading());
    try {
      List<MessageEntity> dataList = [];
      dataList.clear();
      final result = service.getMessages(roomId: roomId);

      result.listen((snapshot) {
        log('snapshot: ${snapshot.docs}');
        if (List.of(snapshot.docs).isNotEmpty) {
          for (var doc in snapshot.docs) {
            log('doc: ${doc.data()}');
            final data = doc.data();
            final message = MessageEntity.fromJson(data);
            dataList.add(message);
            print('dataList: $dataList');
            emit(MessageLoaded(dataList));
          }
        } else {
          emit(MessageEmpty());
        }
      });

      if (List.of(dataList).isNotEmpty) {
        log('success');
        emit(MessageLoaded(dataList));
      } else {
        log('failed');

        emit(MessageError('failed'));
      }
    } catch (error) {
      log('error $error');

      emit(MessageError(error.toString()));
    }
  }

  // getMessages({required String roomId}) async {
  //   List<MessageEntity> messageList = [];
  //   messageList.clear();
  //
  //   emit(MessageLoading());
  //
  //   try {
  //     final messages = service.getMessages();
  //
  //     messages.listen((snapshot) {
  //       log('snapshot: ${snapshot.docs}');
  //       if (List.of(snapshot.docs).isNotEmpty) {
  //         messageList.clear();
  //
  //         for (var doc in snapshot.docs) {
  //           log('doc: ${doc.data()}');
  //           final message = MessageEntity(
  //             message: doc.data()['text'],
  //             createdAt: (doc.data()['createdAt'] as Timestamp).toDate(),
  //             userId: doc.data()['userId'],
  //             imageUrl: doc.data()['imageUrl'],
  //             messageId: doc.data()['messageId'],
  //           );
  //           messageList.add(message);
  //
  //           emit(MessageLoaded(messageList));
  //         }
  //       } else {
  //         emit(MessageEmpty());
  //       }
  //     });
  //   } catch (error) {
  //     emit(MessageError(error.toString()));
  //     return null;
  //   }
  // }
}
