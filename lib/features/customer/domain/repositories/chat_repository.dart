import '../../../../core/utils/result.dart';
import '../models/chat.dart';
import '../models/message.dart';
abstract interface class ChatRepository { Future<Result<List<Chat>>> getChats(); Future<Result<List<Message>>> getMessages(String chatId); Future<Result<Message>> sendMessage(String chatId,String text); }
