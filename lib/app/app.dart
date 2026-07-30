import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/config/api_config.dart';
import '../core/network/api_client.dart';
import '../core/storage/locale_storage.dart';
import '../core/storage/token_storage.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/customer/data/datasources/category_remote_datasource.dart';
import '../features/customer/data/datasources/chat_remote_datasource.dart';
import '../features/customer/data/datasources/order_remote_datasource.dart';
import '../features/customer/data/datasources/user_remote_datasource.dart';
import '../features/customer/data/repositories/category_repository_impl.dart';
import '../features/customer/data/repositories/chat_repository_impl.dart';
import '../features/customer/data/repositories/order_repository_impl.dart';
import '../features/customer/data/repositories/user_repository_impl.dart';
import '../features/customer/domain/repositories/category_repository.dart';
import '../features/customer/domain/repositories/chat_repository.dart';
import '../features/customer/domain/repositories/order_repository.dart';
import '../features/customer/domain/repositories/user_repository.dart';
import '../features/proposals/data/datasources/offer_remote_datasource.dart';
import '../features/proposals/data/repositories/offer_repository_impl.dart';
import '../features/proposals/domain/repositories/offer_repository.dart';
import '../features/reviews/data/datasources/review_remote_datasource.dart';
import '../features/reviews/data/repositories/review_repository_impl.dart';
import '../features/reviews/domain/repositories/review_repository.dart';
import '../l10n/app_localizations.dart';
import '../l10n/locale_controller.dart';
import 'bootstrap/app_config.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

final class App extends StatefulWidget {
  const App({required this.config, super.key});

  final AppConfig config;

  @override
  State<App> createState() => _AppState();
}

final class _AppState extends State<App> {
  late final TokenStorage _tokenStorage = SecureTokenStorage();
  late final LocaleController _localeController = LocaleController(
    storage: SecureLocaleStorage(),
  );
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
  late final ChatRepository _chatRepository = ChatRepositoryImpl(
    remoteDataSource: ChatRemoteDataSourceImpl(apiClient: _apiClient),
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
    chatRepository: _chatRepository,
    orderRepository: _orderRepository,
    userRepository: _userRepository,
    offerRepository: _offerRepository,
    reviewRepository: _reviewRepository,
    tokenStorage: _tokenStorage,
    ordersRefreshNotifier: _ordersRefreshNotifier,
  );

  @override
  void initState() {
    super.initState();
    _localeController.restore();
  }

  @override
  void dispose() {
    _ordersRefreshNotifier.dispose();
    _localeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale?>(
      valueListenable: _localeController,
      builder: (context, locale, child) => LocaleScope(
        controller: _localeController,
        child: MaterialApp.router(
          title: widget.config.appName,
          theme: AppTheme.light,
          locale: locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: _appRouter.router,
        ),
      ),
    );
  }
}
