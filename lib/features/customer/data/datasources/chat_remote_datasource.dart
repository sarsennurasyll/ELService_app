import '../../../../core/errors/api_exception.dart';
import '../../../../core/network/api_client.dart';
import '../models/chat_dto.dart';
import '../models/message_dto.dart';

abstract interface class ChatRemoteDataSource {
  Future<List<ChatDto>> getChats();

  Future<ChatDto> createChat(String orderId);

  Future<List<MessageDto>> getMessages(String chatId);

  Future<MessageDto> sendMessage(String chatId, String text);
}

final class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  const ChatRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<List<ChatDto>> getChats() async {
    final response = await _apiClient.get('/chats');
    final data = response['data'];
    if (data is! List) {
      throw const ApiException(message: 'Некорректный ответ сервера');
    }

    return data.map(_chatFromJson).toList();
  }

  @override
  Future<ChatDto> createChat(String orderId) async {
    final response = await _apiClient.post(
      '/chats',
      body: {'orderId': orderId},
    );
    return _chatFromJson(response['data']);
  }

  @override
  Future<List<MessageDto>> getMessages(String chatId) async {
    final response = await _apiClient.get('/chats/$chatId/messages');
    final data = response['data'];
    if (data is! List) {
      throw const ApiException(message: 'Некорректный ответ сервера');
    }

    return data.map(_messageFromJson).toList();
  }

  @override
  Future<MessageDto> sendMessage(String chatId, String text) async {
    final response = await _apiClient.post(
      '/chats/$chatId/messages',
      body: {'text': text},
    );
    return _messageFromJson(response['data']);
  }

  ChatDto _chatFromJson(dynamic json) {
    if (json is! Map) {
      throw const ApiException(message: 'Некорректный ответ сервера');
    }
    return ChatDto.fromMap(Map<String, dynamic>.from(json));
  }

  MessageDto _messageFromJson(dynamic json) {
    if (json is! Map) {
      throw const ApiException(message: 'Некорректный ответ сервера');
    }
    return MessageDto.fromMap(Map<String, dynamic>.from(json));
  }
}
