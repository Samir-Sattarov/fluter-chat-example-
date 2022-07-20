import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';

import '../../../domain/entity/message_entity.dart';
import '../../../domain/entity/user_entity.dart';
import '../../../domain/services/user_service.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserService service;
  UserCubit(this.service) : super(UserInitial());

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
        emit(SuccessSearch(data: data));
      } else {
        log('failed');

        emit(FailedSearch());
      }
    } catch (error) {
      log('error $error');

      emit(Error(error.toString()));
    }
  }

  sendMessage({
    required UserEntity userEntity,
    required String? message,
    required String roomId,
  }) async {
    try {
      final reuslt = await service.sendMessage(
        userEntity: userEntity,
        message: message,
        roomId: roomId,
      );

      if (reuslt == true) {
        log('message send');
      } else {
        log('message not send');
      }
    } catch (error) {
      log('error $error');
      emit(Error(error.toString()));
    }
  }

  getMessages({required String roomId}) async {
    emit(Loading());
    try {
      List<MessageEntity> data = [];
      final result = await service.getMessages(roomId: roomId);
      log(result.toString());

      result.map((entity) => data.add(entity)).toList();

      if (List.of(data).isNotEmpty) {
        log('success');
        emit(SuccessMessages(data));
      } else {
        log('failed');

        emit(FailedMessages());
      }
    } catch (error) {
      log('error $error');

      emit(Error(error.toString()));
    }
  }
}
