import 'package:flutter/material.dart';

import '../core/config/api_config.dart';
import '../core/network/api_client.dart';
import '../core/storage/token_storage.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import 'bootstrap/app_config.dart';
import 'router/app_router.dart';

final class App extends StatefulWidget {
  const App({required this.config, super.key});

  final AppConfig config;

  @override
  State<App> createState() => _AppState();
}

final class _AppState extends State<App> {
  late final TokenStorage _tokenStorage = SecureTokenStorage();
  late final ApiClient _apiClient = ApiClient(
    config: ApiConfig(baseUrl: widget.config.apiBaseUrl),
    tokenStorage: _tokenStorage,
  );
  late final AuthRepository _authRepository = AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSourceImpl(apiClient: _apiClient),
    tokenStorage: _tokenStorage,
  );
  late final AppRouter _appRouter = AppRouter(
    authRepository: _authRepository,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: widget.config.appName,
      routerConfig: _appRouter.router,
    );
  }
}
