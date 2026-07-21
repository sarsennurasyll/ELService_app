final class MessageDto {
  const MessageDto({required this.id, required this.chatId, required this.senderId, required this.text, required this.createdAt});
  final String id; final String chatId; final String senderId; final String text; final DateTime createdAt;
  factory MessageDto.fromMap(Map<String,dynamic> map) { final id=map['id']; final chatId=map['conversationId']; final senderId=map['senderId']; final text=map['text']; final createdAt=map['createdAt']; if(id is! String||chatId is! String||senderId is! String||text is! String||createdAt is! String) throw const FormatException('Некорректные данные сообщения'); final date=DateTime.tryParse(createdAt); if(date==null) throw const FormatException('Некорректная дата сообщения'); return MessageDto(id:id,chatId:chatId,senderId:senderId,text:text,createdAt:date); }
}
