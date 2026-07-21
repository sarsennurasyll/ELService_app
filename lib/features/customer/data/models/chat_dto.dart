final class ChatDto {
  const ChatDto({
    required this.id,
    required this.orderId,
    required this.userAId,
    required this.userBId,
    this.lastMessage,
  });

  final String id;
  final String orderId;
  final String userAId;
  final String userBId;
  final String? lastMessage;

  factory ChatDto.fromMap(Map<String, dynamic> map) {
    final id = map['id'];
    final orderId = map['orderId'];
    final userAId = map['userAId'];
    final userBId = map['userBId'];
    if (id is! String || orderId is! String || userAId is! String || userBId is! String) {
      throw const FormatException('Некорректные данные чата');
    }
    final messages = map['messages'];
    final lastMessage = messages is List && messages.isNotEmpty && messages.first is Map
        ? (messages.first as Map)['text'] as String?
        : null;
    return ChatDto(id: id, orderId: orderId, userAId: userAId, userBId: userBId, lastMessage: lastMessage);
  }
}
