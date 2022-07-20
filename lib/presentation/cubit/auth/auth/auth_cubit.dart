import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../storage/secure_storage.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SecureStorage storage;

  AuthCubit(this.storage) : super(UserDontRegistered()) {
    _userState();
  }

  _userState() async {
    try {
      const email = 'email';
      final emailFromStorage = await storage.get(key: email);
      print('$emailFromStorage is email');

      if (emailFromStorage.toString().isEmpty || emailFromStorage == null) {
        emit(UserDontRegistered());
      } else {
        emit(UserWasRegistered());
      }
    } catch (error) {
      print(error.toString());
      throw Exception(error.toString());
    }
  }
}
