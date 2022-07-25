import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/chat_room_entity.dart';
import '../../../domain/entity/user_entity.dart';
import '../../../domain/services/message_services.dart';

part 'chat_room_state.dart';

class ChatRoomCubit extends Cubit<ChatRoomState> {
  final MessageService service;

  ChatRoomCubit(this.service) : super(ChatRoomInitial());

  load({
    required UserEntity targetUser,
    required UserEntity entity,
  }) async {
    try {
      emit(ChatRoomLoading());

      final ChatRoomEntity chatRoom = await service.getChatRoomEntity(
        targetUser: targetUser,
        user: entity,
      );

      emit(ChatRoomLoaded(chatRoom: chatRoom));
    } catch (error) {
      emit(ChatRoomFailure(error.toString()));
    }
  }
}
