import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../entity/user_entity.dart';

class UserService {
  final collection = 'users';
  final storage = FirebaseStorage.instance;
  final fireStore = FirebaseFirestore.instance;
  final fireAuth = FirebaseAuth.instance;

  Future<bool> uploadData({
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
      log('error $error');
      throw Exception(error.toString());
    }
  }

  Future<List<UserEntity>> search({required String name}) async {
    try {
      List<UserEntity> data = [];

      final result = await fireStore
          .collection(collection)
          .where('name', isEqualTo: name)
          .get();

      log(result.toString());

      for (var element in result.docs) {
        data.add(UserEntity.fromJson(element.data()));
      }

      return data;
    } catch (error) {
      log('error $error');

      throw Exception(error.toString());
    }
  }

  Future<List<UserEntity>> getUsers({
    required String currentUserId,
  }) async {
    try {
      List<UserEntity> dataList = [];

      final result = await fireStore
          .collection(collection)
          .where('uid', isNotEqualTo: currentUserId)
          .get();

      log(result.toString());

      for (var element in result.docs) {
        dataList.add(UserEntity.fromJson(element.data()));
      }

      return dataList;
    } catch (error) {
      log('error $error');

      throw Exception(error.toString());
    }
  }

  Future<UserEntity?>? getCurrentUser() async {
    try {
      final user = fireAuth.currentUser;

      if (user != null) {
        final result =
            await fireStore.collection(collection).doc(user.uid).get();

        if (result.exists) {
          return UserEntity.fromJson(result.data() as Map<String, dynamic>);
        }
      }
      return null;
    } catch (error) {
      log('error $error');

      throw Exception(error.toString());
    }
  }
}
