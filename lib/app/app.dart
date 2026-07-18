import 'package:flutter/material.dart';

import 'bootstrap/app_config.dart';

final class App extends StatefulWidget {
  const App({required this.config, super.key});

  final AppConfig config;

  @override
  State<App> createState() => _AppState();
}

final class _AppState extends State<App> {
  // Временная конфигурация до подключения полноценного Router.
  late final RouterConfig<Object> _routerConfig = RouterConfig<Object>(
    routerDelegate: _TemporaryRouterDelegate(),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: widget.config.appName,
      routerConfig: _routerConfig,
    );
  }
}

final class _TemporaryRouterDelegate extends RouterDelegate<Object>
    with ChangeNotifier {
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();

  @override
  Future<void> setNewRoutePath(Object configuration) => Future.value();
}
