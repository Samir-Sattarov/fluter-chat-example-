class ChatRoomEntity {
  final String? roomId;
  final Map<String, dynamic>? participants;
  final String? lastMessage;

  ChatRoomEntity({
    required this.roomId,
    required this.participants,
    required this.lastMessage,
  });

  factory ChatRoomEntity.fromJson(Map<String, dynamic> json) {
    return ChatRoomEntity(
      participants: json['participants'],
      roomId: json['roomId'],
      lastMessage: json['lastMessage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "roomId": roomId,
      "participants": participants,
      "lastMessage": lastMessage,
    };
  }
}
