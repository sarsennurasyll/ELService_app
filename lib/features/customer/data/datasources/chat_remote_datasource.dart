import '../../../../core/errors/api_exception.dart';
import '../../../../core/network/api_client.dart';
import '../models/chat_dto.dart';
import '../models/message_dto.dart';
abstract interface class ChatRemoteDataSource { Future<List<ChatDto>> getChats(); Future<List<MessageDto>> getMessages(String chatId); Future<MessageDto> sendMessage(String chatId,String text); }
final class ChatRemoteDataSourceImpl implements ChatRemoteDataSource { const ChatRemoteDataSourceImpl({required ApiClient apiClient}):_apiClient=apiClient; final ApiClient _apiClient;
@override Future<List<ChatDto>> getChats() async {final response=await _apiClient.get('/chats');final data=response['data'];if(data is! List)throw const ApiException(message:'Некорректный ответ сервера');return data.map((value)=>ChatDto.fromMap(Map<String,dynamic>.from(value as Map))).toList();}
@override Future<List<MessageDto>> getMessages(String chatId) async {final response=await _apiClient.get('/chats/$chatId/messages');final data=response['data'];if(data is! List)throw const ApiException(message:'Некорректный ответ сервера');return data.map((value)=>MessageDto.fromMap(Map<String,dynamic>.from(value as Map))).toList();}
@override Future<MessageDto> sendMessage(String chatId,String text) async {final response=await _apiClient.post('/chats/$chatId/messages',body:{'text':text});final data=response['data'];if(data is! Map)throw const ApiException(message:'Некорректный ответ сервера');return MessageDto.fromMap(Map<String,dynamic>.from(data));}}
