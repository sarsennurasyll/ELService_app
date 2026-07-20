import '../../domain/models/message.dart';
import '../models/message_dto.dart';

/// Маппер MessageDto ↔ Message.
final class MessageMapper {
  const MessageMapper();

  Message fromDto(MessageDto dto) {
    // TODO: согласовать формат даты с Backend.
    return Message(
      id: dto.id,
      orderId: dto.orderId,
      senderId: dto.senderId,
      text: dto.text,
      createdAt: DateTime.parse(dto.createdAt),
    );
  }

  MessageDto toDto(Message entity) {
    return MessageDto(
      id: entity.id,
      orderId: entity.orderId,
      senderId: entity.senderId,
      text: entity.text,
      createdAt: entity.createdAt.toIso8601String(),
    );
  }
}
