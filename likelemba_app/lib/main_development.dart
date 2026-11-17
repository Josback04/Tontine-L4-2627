import 'package:likelemba_app/app/app.dart';
import 'package:likelemba_app/bootstrap.dart';
import 'package:likelemba_app/core/config/app_environment.dart';

Future<void> main() async {
  await bootstrap(() => const App(), environment: AppEnvironment.development);
}
