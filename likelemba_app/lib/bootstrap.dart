import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:likelemba_app/core/config/app_environment.dart';
import 'package:likelemba_app/core/di/injection_container.dart';

class AppBlocObserver extends BlocObserver {
  const new();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

/// Démarrage commun aux trois saveurs : observateur de blocs, injection des
/// dépendances, puis l'application.
Future<void> bootstrap(
  FutureOr<Widget> Function() builder, {
  required AppEnvironment environment,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  await initDependencies(environment);

  runApp(await builder());
}
