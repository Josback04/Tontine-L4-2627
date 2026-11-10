import 'package:dio/dio.dart';
import 'package:likelemba_app/core/config/app_environment.dart';

/// Construit le client HTTP partagé par toutes les features.
Dio createDio(
  AppEnvironment environment, {
  List<Interceptor> interceptors = const [],
}) => Dio(
  BaseOptions(
    baseUrl: environment.apiBaseUrl,
    connectTimeout: environment.networkTimeout,
    receiveTimeout: environment.networkTimeout,
    contentType: Headers.jsonContentType,
  ),
)..interceptors.addAll(interceptors);
