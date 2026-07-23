import 'package:flutter/material.dart';

import '../core/config/api_config.dart';
import '../core/network/api_client.dart';
import '../core/storage/token_storage.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/customer/data/datasources/category_remote_datasource.dart';
import '../features/customer/data/datasources/order_remote_datasource.dart';
import '../features/customer/data/datasources/user_remote_datasource.dart';
import '../features/customer/data/repositories/category_repository_impl.dart';
import '../features/customer/data/repositories/order_repository_impl.dart';
import '../features/customer/data/repositories/user_repository_impl.dart';
import '../features/customer/domain/repositories/category_repository.dart';
import '../features/customer/domain/repositories/order_repository.dart';
import '../features/customer/domain/repositories/user_repository.dart';
import '../features/proposals/data/datasources/offer_remote_datasource.dart';
import '../features/proposals/data/repositories/offer_repository_impl.dart';
import '../features/proposals/domain/repositories/offer_repository.dart';
import '../features/reviews/data/datasources/review_remote_datasource.dart';
import '../features/reviews/data/repositories/review_repository_impl.dart';
import '../features/reviews/domain/repositories/review_repository.dart';
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
  late final CategoryRepository _categoryRepository = CategoryRepositoryImpl(
    remoteDataSource: CategoryRemoteDataSourceImpl(apiClient: _apiClient),
  );
  late final OrderRepository _orderRepository = OrderRepositoryImpl(
    remoteDataSource: OrderRemoteDataSourceImpl(apiClient: _apiClient),
  );
  late final UserRepository _userRepository = UserRepositoryImpl(
    remoteDataSource: UserRemoteDataSourceImpl(apiClient: _apiClient),
  );
  late final OfferRepository _offerRepository = OfferRepositoryImpl(
    remoteDataSource: OfferRemoteDataSourceImpl(apiClient: _apiClient),
  );
  late final ReviewRepository _reviewRepository = ReviewRepositoryImpl(
    remoteDataSource: ReviewRemoteDataSourceImpl(apiClient: _apiClient),
  );
  late final ValueNotifier<int> _ordersRefreshNotifier = ValueNotifier(0);
  late final AppRouter _appRouter = AppRouter(
    authRepository: _authRepository,
    categoryRepository: _categoryRepository,
    orderRepository: _orderRepository,
    userRepository: _userRepository,
    offerRepository: _offerRepository,
    reviewRepository: _reviewRepository,
    tokenStorage: _tokenStorage,
    ordersRefreshNotifier: _ordersRefreshNotifier,
  );

  @override
  void dispose() {
    _ordersRefreshNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: widget.config.appName,
      routerConfig: _appRouter.router,
    );
  }
}
