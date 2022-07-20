import 'dart:io';

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

  Future<List<UserEntity>> getUsers() async {
    try {
      List<UserEntity> data = [];

      final result = await fireStore.collection(collection).get();

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
}
