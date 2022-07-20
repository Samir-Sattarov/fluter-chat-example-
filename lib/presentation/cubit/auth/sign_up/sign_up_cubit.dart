import 'package:bloc/bloc.dart';
import 'package:chat_example/domain/entity/user_entity.dart';
import 'package:chat_example/domain/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthService service;
  SignUpCubit(this.service) : super(SignUpInitial());

  signUp({
    required String email,
    required String password,
  }) async {
    emit(SignUpLoading());
    try {
      final result = await service.signUp(
        email: email,
        password: password,
      );

      if (result != null) {
        emit(SignUpSuccess(result));
      } else {
        emit(SignUpError('Error null'));
      }
    } on FirebaseAuthException catch (error) {
      emit(SignUpError(error.toString()));
    }
  }

  reset() {
    emit(SignUpInitial());
  }
}
