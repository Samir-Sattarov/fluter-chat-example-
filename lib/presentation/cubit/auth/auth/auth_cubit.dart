import 'package:chat_example/domain/entity/user_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/services/user_service.dart';
import '../../../storage/secure_storage.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SecureStorage storage;
  final UserService service;

  AuthCubit(this.storage, this.service) : super(AuthInitial()) {
    _userState();
  }

  _userState() async {
    emit(AuthLoading());
    try {
      const email = 'email';
      final emailFromStorage = await storage.get(key: email);
      print('$emailFromStorage is email');

      final result = await service.getCurrentUser();

      if (emailFromStorage.toString().isEmpty ||
          emailFromStorage == null && result == null) {
        emit(UserDontRegistered());
      } else {
        emit(UserWasRegistered(result!));
      }
    } catch (error) {
      print(error.toString());
      emit(AuthError(error.toString()));
    }
  }
}
