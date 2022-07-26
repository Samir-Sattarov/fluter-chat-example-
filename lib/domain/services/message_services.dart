import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../main.dart';
import '../entity/chat_room_entity.dart';
import '../entity/message_entity.dart';
import '../entity/user_entity.dart';

class MessageService {
  final fireStore = FirebaseFirestore.instance;
  final fireStorage = FirebaseStorage.instance;
  final _chatRoomCollection = 'chatRooms';
  final _messageCollection = 'messages';

  sendMessage({
    required UserEntity currentUser,
    required UserEntity receiver,
    required String? message,
    required String roomId,
    MessageEntity? replayMessage,
    File? image,
  }) async {
    try {
      String? imageFromServer;

      if (image != null) {
        UploadTask uploadTask = fireStorage
            .ref()
            .child('chat_images')
            .child(currentUser.uid.toString())
            .putFile(image);

        TaskSnapshot snapshot = await uploadTask;
        String imageUrl = await snapshot.ref.getDownloadURL();
        imageFromServer = imageUrl;
      }

      String type = getMessageType(
        message: message,
        image: imageFromServer,
      );
      MessageEntity newMessage = MessageEntity(
        messageId: uuid.v1(),
        message: message,
        createdDate: DateTime.now(),
        senderId: currentUser.uid,
        receiverId: receiver.uid,
        image: imageFromServer,
        senderName: currentUser.fullName,
        replyMessage: replayMessage,
        isRead: false,
        messageType: type,
      );

      await fireStore.collection(_chatRoomCollection).doc(roomId).update({
        'lastMessage': newMessage.toJson(),
      });

      await fireStore
          .collection(_chatRoomCollection)
          .doc(roomId)
          .collection(_messageCollection)
          .doc(newMessage.messageId)
          .set(newMessage.toJson());

      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }

  getMessageType({required String? message, required String? image}) {
    if (message != null && message.isNotEmpty) {
      return 'text';
    } else if (image != null && image.isNotEmpty) {
      return 'image';
    } else if (message != null &&
        message.isNotEmpty &&
        image != null &&
        image.isNotEmpty) {
      return 'textWithImage';
    } else {
      return 'text';
    }
  }

  Future<int> getNotReadMessageForChatRoomEntityCount(
    ChatRoomEntity chatRoom,
    UserEntity sender,
  ) async {
    try {
      QuerySnapshot snap = await fireStore
          .collection(_chatRoomCollection)
          .doc(chatRoom.roomId)
          .collection(_messageCollection)
          .where('senderId', isEqualTo: sender.uid)
          .where('isRead', isEqualTo: false)
          .get();

      return snap.docs.length;
    } catch (error) {
      return 1000;
    }
  }

  getNewMessage(
    UserEntity user,
  ) {
    try {
      List<ChatRoomEntity> chatRoomList = [];
      List<MessageEntity> messageList = [];

      final chatRooms = fireStore
          .collection(_chatRoomCollection)
          .where('participants.${user.uid}', isEqualTo: true)
          .snapshots();

      chatRooms.listen((snapshot) {
        for (var doc in snapshot.docs) {
          chatRoomList.add(ChatRoomEntity.fromJson(doc.data()));
        }

        chatRoomList.forEach((element) async {
          QuerySnapshot snap = await fireStore
              .collection(_chatRoomCollection)
              .doc(element.roomId)
              .collection(_messageCollection)
              .where('senderId', isNotEqualTo: user.uid)
              .where('isRead', isEqualTo: false)
              .get();

          for (var doc in snap.docs) {
            messageList.add(MessageEntity.fromJson(doc.data()));
          }
        });
      });
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  void updateAllMessageToRead({
    required String roomId,
    required UserEntity me,
  }) async {
    try {
      final bool isMe;
      await fireStore
          .collection(_chatRoomCollection)
          .doc(roomId)
          .collection(_messageCollection)
          .where('senderId', isNotEqualTo: me.uid)
          .get()
          .then((value) {
        for (var element in value.docs) {
          fireStore
              .collection(_chatRoomCollection)
              .doc(roomId)
              .collection(_messageCollection)
              .doc(element.id)
              .update({
            'isRead': true,
          });
        }
      });

      final DocumentSnapshot<Map<String, dynamic>> chatRoom =
          await fireStore.collection(_chatRoomCollection).doc(roomId).get();

      if (chatRoom['lastMessage'] != null) {
        isMe = chatRoom['lastMessage']['senderId'] == me.uid ? true : false;
      } else {
        isMe = false;
      }

      if (!isMe &&
          chatRoom['lastMessage'] != null &&
          chatRoom['lastMessage']['isRead'] == false) {
        fireStore.collection(_chatRoomCollection).doc(roomId).update({
          'lastMessage.isRead': true,
        });
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<ChatRoomEntity> getChatRoomEntity({
    required UserEntity targetUser,
    required UserEntity user,
  }) async {
    try {
      ChatRoomEntity? chatRoomEntity;
      QuerySnapshot snapshot = await fireStore
          .collection(_chatRoomCollection)
          .where('participants.${targetUser.uid}', isEqualTo: true)
          .where('participants.${user.uid}', isEqualTo: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final dataFromDoc = snapshot.docs.first.data();

        final ChatRoomEntity existChatroom =
            ChatRoomEntity.fromJson(dataFromDoc as Map<String, dynamic>);

        chatRoomEntity = existChatroom;
        return chatRoomEntity;
      } else {
        final id = uuid.v1();
        ChatRoomEntity newChatRoomEntityEntity = ChatRoomEntity(
          roomId: id,
          participants: {
            user.uid.toString(): true,
            targetUser.uid.toString(): true,
          },
          lastMessage: null,
        );

        await fireStore
            .collection(_chatRoomCollection)
            .doc(newChatRoomEntityEntity.roomId)
            .set(newChatRoomEntityEntity.toMap());

        chatRoomEntity = newChatRoomEntityEntity;

        return chatRoomEntity;
      }
    } catch (error) {
      log(error.toString());
      throw Exception(error.toString());
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage({
    required String userId,
    required String senderId,
  }) {
    try {
      final result = fireStore
          .collection(_chatRoomCollection)
          .where('participants.$userId', isEqualTo: true)
          .where('participants.$senderId', isEqualTo: true)
          .snapshots();

      return result;
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages({
    required String roomId,
  }) {
    try {
      final result = fireStore
          .collection(_chatRoomCollection)
          .doc(roomId)
          .collection(_messageCollection)
          .orderBy('createdAt', descending: true)
          .snapshots();

      return result;
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
