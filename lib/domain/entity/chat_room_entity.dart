import 'package:chat_example/domain/entity/message_entity.dart';

class ChatRoomEntity {
  final String roomId;
  final Map<String, dynamic>? participants;
  final MessageEntity? lastMessage;

  const ChatRoomEntity({
    required this.roomId,
    required this.participants,
    required this.lastMessage,
  });

  factory ChatRoomEntity.fromJson(Map<String, dynamic> json) {
    return ChatRoomEntity(
      participants: json['participants'],
      roomId: json['roomId'],
      lastMessage: json['lastMessage'] != null
          ? MessageEntity.fromJson(json['lastMessage'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "roomId": roomId,
      "participants": participants,
      "lastMessage": lastMessage?.toJson(),
    };
  }
}
