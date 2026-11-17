import 'dart:async';

import 'package:dio/dio.dart';

/// Joint le jeton à chaque requête et réagit au 401.
///
/// L'intercepteur ne connaît ni AuthBloc, ni le routeur, ni la source locale :
/// il reçoit trois fonctions, branchées par core/di/injection_container.dart.
/// Ainsi core/ ne dépend d'aucune feature/fonctionnalités
class AuthInterceptor extends Interceptor {
  new({
    required this._readToken,
    required this._clearSession,
    required this._onSessionExpired,
  });

  final String? Function() _readToken;
  final Future<void> Function() _clearSession;
  final void Function() _onSessionExpired;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _readToken();
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final isAuthRoute = err.requestOptions.path.startsWith('/auth/');
    if (err.response?.statusCode == 401 && !isAuthRoute) {
      unawaited(_clearSession().whenComplete(_onSessionExpired));
    }
    handler.next(err);
  }
}
