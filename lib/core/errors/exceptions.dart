class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException([
    this.message = 'Server error occurred',
    this.statusCode,
  ]);

  @override
  String toString() => 'ServerException($statusCode): $message';
}

class UnauthorizedException implements Exception {
  final String message;

  const UnauthorizedException([this.message = 'Unauthorized']);

  @override
  String toString() => 'UnauthorizedException: $message';
}

class CacheException implements Exception {
  final String message;

  const CacheException([this.message = 'Cache error occurred']);

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException([this.message = 'No internet connection']);

  @override
  String toString() => 'NetworkException: $message';
}
