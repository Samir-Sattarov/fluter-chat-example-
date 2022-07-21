import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/message_entity.dart';
import '../../../domain/entity/user_entity.dart';
import '../../../domain/services/user_service.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserService service;

  UserCubit(this.service) : super(UserInitial());

  final fireAuth = FirebaseAuth.instance;

  uploadNewData({
    required UserEntity userEntity,
    required String name,
    required String surname,
    required File? image,
  }) async {
    emit(Loading());
    try {
      final result = await service.uploadData(
        userEntity: userEntity,
        name: name,
        surname: surname,
        image: image,
      );
      if (result == true) {
        log('successed');
        emit(Success());
      } else {
        log('failed $result');

        emit(Failed());
      }
    } catch (error) {
      emit(Error(error.toString()));
    }
  }

  searchByName({required String name}) async {
    emit(Loading());
    try {
      List<UserEntity> data = [];
      final result = await service.search(name: name);

      result.map((entity) => data.add(entity)).toList();

      log(result.toString());

      if (List.of(data).isNotEmpty) {
        log('success');
        emit(SuccessLoad(data: data));
      } else {
        log('failed');

        emit(FailedSearch());
      }
    } catch (error) {
      log('error $error');

      emit(Error(error.toString()));
    }
  }

  getUsers() async {
    emit(Loading());
    try {
      final currentUserId = fireAuth.currentUser!.uid;
      List<UserEntity> data = [];
      final result = await service.getUsers(currentUserId: currentUserId);

      result.map((entity) => data.add(entity)).toList();

      log(result.toString());

      if (List.of(data).isNotEmpty) {
        log('success');
        emit(SuccessLoad(data: data));
      } else {
        log('failed');

        emit(FailedSearch());
      }
    } catch (error) {
      log('error $error');

      emit(Error(error.toString()));
    }
  }
}
