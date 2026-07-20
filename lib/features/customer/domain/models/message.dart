/// Доменная модель сообщения чата.
final class Message {
  const Message({
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
  final DateTime createdAt;
}
