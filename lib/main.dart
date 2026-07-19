import 'app/app.dart';
import 'app/bootstrap/app_config.dart';
import 'app/bootstrap/app_environment.dart';
import 'app/bootstrap/bootstrap.dart';

Future<void> main() async {
  const config = AppConfig(
    environment: AppEnvironment.development,
    appName: 'ELService',
    apiBaseUrl: 'https://api.elservice.dev',
    enableLogger: true,
  );

  bootstrap(
    config: config,
    appBuilder: (config) => App(config: config),
  );
}
