import 'package:dio/dio.dart';

import '../../utils/logger.dart';

class LoggingInterceptor extends Interceptor {
  static const String _tag = 'HTTP';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.debug('--> ${options.method} ${options.uri}', tag: _tag);
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    AppLogger.debug(
      '<-- ${response.statusCode} ${response.requestOptions.uri}',
      tag: _tag,
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      '<-- ${err.response?.statusCode ?? err.type.name} '
      '${err.requestOptions.uri}',
      error: err.message,
    );
    handler.next(err);
  }
}
