import 'package:likelemba_app/app/app.dart';
import 'package:likelemba_app/bootstrap.dart';
import 'package:likelemba_app/core/config/app_environment.dart';
import 'package:likelemba_app/core/di/injection_container.dart';

Future<void> main() async {
  await bootstrap(
    () => App(authBloc: sl()),
    environment: AppEnvironment.development,
  );
}
