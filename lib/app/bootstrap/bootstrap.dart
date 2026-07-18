import 'dart:async';

import 'package:flutter/widgets.dart';

import 'app_config.dart';

typedef AppBuilder = Widget Function(AppConfig config);

void bootstrap({
  required AppConfig config,
  required AppBuilder appBuilder,
}) {
  WidgetsFlutterBinding.ensureInitialized();

  runZonedGuarded<void>(
    () {
      // TODO: Добавить инициализацию общих сервисов приложения.
      runApp(appBuilder(config));
    },
    (error, stackTrace) {
      // TODO: Подключить централизованную обработку ошибок.
      Zone.current.handleUncaughtError(error, stackTrace);
    },
  );
}
