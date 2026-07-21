import '../../../../core/errors/api_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/network_exception.dart';
import '../../../../core/utils/result.dart';
import '../../domain/models/chat.dart';
import '../../domain/models/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';
import '../models/message_dto.dart';

final class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl({required ChatRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final ChatRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<Chat>>> getChats() async {
    try { final values=await _remoteDataSource.getChats(); return Success(values.map((value)=>Chat(id:value.id,orderId:value.orderId,userAId:value.userAId,userBId:value.userBId,lastMessage:value.lastMessage)).toList()); } on Exception catch (error) { return ErrorResult(_failure(error)); }
  }

  @override
  Future<Result<List<Message>>> getMessages(String chatId) async {
    try { final values=await _remoteDataSource.getMessages(chatId); return Success(values.map(_message).toList()); } on Exception catch (error) { return ErrorResult(_failure(error)); }
  }

  @override
  Future<Result<Message>> sendMessage(String chatId, String text) async {
    try { return Success(_message(await _remoteDataSource.sendMessage(chatId, text))); } on Exception catch (error) { return ErrorResult(_failure(error)); }
  }

  Failure _failure(Exception error) => error is ApiException ? Failure(message: error.message, code: error.code, statusCode: error.statusCode) : error is NetworkException ? Failure(message: error.message) : Failure(message: error.toString());
  Message _message(MessageDto value)=>Message(id:value.id,orderId:value.chatId,senderId:value.senderId,text:value.text,createdAt:value.createdAt);
}
