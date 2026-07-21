import '../../domain/models/message.dart';
import '../models/message_dto.dart';

final class MessageMapper {
  const MessageMapper();

  MessageDto fromMap(Map<String, dynamic> map) => MessageDto.fromMap(map);

  Message fromDto(MessageDto dto) => Message(
    id: dto.id,
    orderId: dto.chatId,
    senderId: dto.senderId,
    text: dto.text,
    createdAt: dto.createdAt,
  );
}
