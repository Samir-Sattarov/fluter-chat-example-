import 'dart:developer';
import 'dart:io';

import 'package:chat_example/domain/entity/message_entity.dart';
import 'package:chat_example/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../entity/user_entity.dart';

class UserService {
  final collection = 'users';
  final storage = FirebaseStorage.instance;
  final fireStore = FirebaseFirestore.instance;

  Future<bool?>? uploadData({
    required UserEntity userEntity,
    required String name,
    required String surname,
    required File? image,
  }) async {
    try {
      UploadTask uploadTask = storage
          .ref('profilePictures')
          .child(userEntity.uid.toString())
          .putFile(image!);

      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      userEntity.name = name;
      userEntity.surname = surname;
      userEntity.image = imageUrl;

      await fireStore
          .collection(collection)
          .doc(userEntity.uid)
          .set(userEntity.toMap());
      return true;
    } catch (error) {
      print('error $error');
    }
    return false;
  }

  Future<List<UserEntity>> search({required String name}) async {
    try {
      List<UserEntity> data = [];

      final result = await fireStore
          .collection(collection)
          .where('name', isEqualTo: name)
          .get();

      print(result);

      result.docs.forEach((element) {
        data.add(UserEntity.fromJson(element.data()));
      });

      return data;
    } catch (error) {
      print('error $error');

      throw Exception(error.toString());
    }
  }

  sendMessage({
    required UserEntity userEntity,
    required String? message,
    required String roomId,
  }) async {
    try {
      if (message!.isNotEmpty) {
        MessageEntity newMessage = MessageEntity(
          sender: userEntity.uid,
          messageId: uuid.v1(),
          message: message,
          createdDate: DateTime.now(),
          seen: false,
        );

        await fireStore
            .collection('chatrooms')
            .doc(roomId)
            .collection('messages')
            .doc(newMessage.messageId)
            .set(newMessage.toMap());
      }

      return true;
    } catch (error) {
      log('error $error');
      return false;
    }
  }

  Future<List<MessageEntity>> getMessages({required String roomId}) async {
    try {
      List<MessageEntity> data = [];

      final result = await fireStore
          .collection('chatrooms')
          .doc(roomId)
          .collection('messages')
          .get();

      result.docs.forEach((element) {
        data.add(MessageEntity.fromJson(element.data()));
      });

      return data;
    } catch (error) {
      log('error $error');

      throw Exception(error.toString());
    }
  }
}
