import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/chat_remote_datasource.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/repositories/chat_repository.dart';
final chatRepositoryProvider = Provider.family<ChatRepository, ApiClient>((ref, apiClient) => ChatRepositoryImpl(remoteDataSource: ChatRemoteDataSourceImpl(apiClient: apiClient)));
