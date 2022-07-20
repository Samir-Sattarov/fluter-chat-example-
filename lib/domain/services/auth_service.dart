import 'dart:developer';

import 'package:chat_example/domain/entity/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../presentation/storage/secure_storage.dart';

class AuthService {
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFireStore = FirebaseFirestore.instance;
  final collectionName = 'users';

  final SecureStorage storage = SecureStorage();
  exit() async {
    await firebaseAuth.signOut();
    const key = 'email';
    storage.delete(key: key);
  }

  Future<UserEntity?>? signIn({
    required String email,
    required String password,
  }) async {
    UserCredential? credential;

    try {
      credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      storage.set(email);
    } on FirebaseAuthException catch (error) {
      log(error.toString());
    }

    if (credential != null) {
      String uid = credential.user!.uid;
      try {
        DocumentSnapshot userData =
            await firebaseFireStore.collection(collectionName).doc(uid).get();

        UserEntity userEntity =
            UserEntity.fromJson(userData.data() as Map<String, dynamic>);

        return userEntity;
      } on FirebaseException catch (error) {
        log(error.toString());
      }
    }
    return null;
  }

  Future<UserEntity?> signUp({
    required String email,
    required String password,
  }) async {
    UserCredential? credential;

    try {
      credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      log(error.toString());
    }

    if (credential != null) {
      String uid = credential.user!.uid;

      log('credential not null creating collection ');
      UserEntity user = UserEntity(
        uid: uid,
        email: email,
        name: '',
        surname: '',
        image: '',
      );
      try {
        await firebaseFireStore
            .collection(collectionName)
            .doc(uid)
            .set(user.toMap());
      } catch (error) {
        log(error.toString());
      }
      return user;
    }
    return null;
  }
}
