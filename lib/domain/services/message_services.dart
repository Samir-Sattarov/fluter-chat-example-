import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../main.dart';
import '../entity/chat_room_entity.dart';
import '../entity/message_entity.dart';
import '../entity/user_entity.dart';

class MessageService {
  final fireStore = FirebaseFirestore.instance;
  final collectionMessages = 'messages';

  sendMessage({
    required UserEntity userEntity,
    required String? message,
    required String roomId,
    required String? imageUrl,
  }) async {
    try {
      if (message!.isNotEmpty) {
        MessageEntity newMessage = MessageEntity(
          messageId: uuid.v1(),
          message: message,
          createdDate: DateTime.now(),
          imageUrl: imageUrl,
          userId: userEntity.uid,
        );

        log('newMessage: $newMessage');

        await fireStore
            .collection('chatrooms')
            .doc(roomId)
            .collection('messages')
            .doc(newMessage.messageId)
            .set(newMessage.toMap());

        log('sended');
      }

      return true;
    } catch (error) {
      log('error $error');
      return false;
    }
  }

  Future<ChatRoomEntity?> getChatRoomEntity({
    required UserEntity targetUser,
    required UserEntity entity,
  }) async {
    ChatRoomEntity? chatRoomEntity;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('chatrooms')
        .where('participants.${entity.uid}', isEqualTo: true)
        .where('participants.${targetUser.uid}', isEqualTo: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final dataFromDoc = snapshot.docs.first.data();
      log('all room already exist $dataFromDoc');

      final ChatRoomEntity existChatroom =
          ChatRoomEntity.fromJson(dataFromDoc as Map<String, dynamic>);

      chatRoomEntity = existChatroom;
      return chatRoomEntity;
    } else {
      log('null');

      ChatRoomEntity newChatRoomEntity = ChatRoomEntity(
        roomId: uuid.v1(),
        participants: {
          entity.uid.toString(): true,
          targetUser.uid.toString(): true,
        },
        lastMessage: "",
      );

      await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(newChatRoomEntity.roomId)
          .set(newChatRoomEntity.toMap());

      chatRoomEntity = newChatRoomEntity;

      log('New chatroom crated');
      return chatRoomEntity;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
      {required String roomId}) {
    try {
      final result = fireStore
          .collection('chatrooms')
          .doc(roomId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .snapshots();

      return result;
    } catch (error) {
      log('error $error');

      throw Exception(error.toString());
    }
  }
}
