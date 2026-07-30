/// Доменная модель сообщения чата.
enum MessageDeliveryStatus { sending, sent, delivered, read }

final class Message {
  const Message({
    required this.id,
    required this.orderId,
    required this.senderId,
    required this.text,
    required this.createdAt,
    this.deliveryStatus = MessageDeliveryStatus.sent,
  });

  final String id;
  final String orderId;
  final String senderId;
  final String text;
  final DateTime createdAt;
  final MessageDeliveryStatus deliveryStatus;

  Message copyWith({MessageDeliveryStatus? deliveryStatus}) {
    return Message(
      id: id,
      orderId: orderId,
      senderId: senderId,
      text: text,
      createdAt: createdAt,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
    );
  }
}
