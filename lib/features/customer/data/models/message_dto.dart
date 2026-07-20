/// DTO сообщения.
///
/// TODO: добавить fromJson / toJson после контракта Backend.
final class MessageDto {
  const MessageDto({
    required this.id,
    required this.orderId,
    required this.senderId,
    required this.text,
    required this.createdAt,
  });

  final String id;
  final String orderId;
  final String senderId;
  final String text;
  final String createdAt;
}
