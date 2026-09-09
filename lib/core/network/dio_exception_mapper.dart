import 'package:dio/dio.dart';

import '../errors/exceptions.dart';

Exception mapDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return const NetworkException('Connection timed out');
    case DioExceptionType.connectionError:
      return const NetworkException();
    case DioExceptionType.cancel:
      return const ServerException('Request was cancelled');
    case DioExceptionType.badCertificate:
      return const ServerException('Invalid server certificate');
    case DioExceptionType.badResponse:
      final statusCode = error.response?.statusCode;
      final message =
          messageFromResponseBody(error.response?.data) ??
          'Request failed with status $statusCode';
      if (statusCode == 401 || statusCode == 403) {
        return UnauthorizedException(message);
      }
      return ServerException(message, statusCode);
    case DioExceptionType.unknown:
      return ServerException(error.message ?? 'Unexpected network error');
  }
}

String? messageFromResponseBody(Object? data) {
  if (data is! Map) {
    return null;
  }
  for (final key in const ['message', 'error', 'detail']) {
    final value = data[key];
    if (value is String && value.isNotEmpty) {
      return value;
    }
  }
  return null;
}
