import 'dart:async';

import 'package:flutter/foundation.dart';

/// Transforme un Stream (celui d'AuthBloc) en Listenable pour go_router :
/// à chaque nouvel état, le routeur réévalue sa redirection.
class GoRouterRefreshStream extends ChangeNotifier {
  new(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
