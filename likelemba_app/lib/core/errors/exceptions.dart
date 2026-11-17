/// Exceptions de la couche data/ : levées par les sources de données,
/// attrapées par les dépôts, qui les traduisent en Failure.
/// Elles ne remontent jamais jusqu'à l'interface.
library;

/// L'API a répondu avec un code d'erreur.
class ServerException implements Exception {
  const new({required this.statusCode, this.code = 'unknown'});

  final int statusCode;

  final String code;

  @override
  String toString() => 'ServerException($statusCode, $code)';
}

/// L'API est injoignable (pas de réseau, délai dépassé, serveur arrêté).
class NetworkException implements Exception {
  const new();
}

/// Le stockage local est vide ou illisible.
class CacheException implements Exception {
  const new();
}
