import 'package:dio/dio.dart';

import '../errors/exceptions.dart';
import 'dio_exception_mapper.dart';
import 'network_info.dart';

abstract class ApiClient {
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  });

  Future<T> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  });

  Future<T> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  });

  Future<T> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  });

  Future<T> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  });
}

class DioApiClient implements ApiClient {
  final Dio dio;
  final NetworkInfo networkInfo;

  DioApiClient({required this.dio, required this.networkInfo});

  @override
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) {
    return _send<T>(
      () => dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      ),
    );
  }

  @override
  Future<T> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) {
    return _send<T>(
      () => dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      ),
    );
  }

  @override
  Future<T> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) {
    return _send<T>(
      () => dio.put<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      ),
    );
  }

  @override
  Future<T> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) {
    return _send<T>(
      () => dio.patch<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      ),
    );
  }

  @override
  Future<T> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) {
    return _send<T>(
      () => dio.delete<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<T> _send<T>(Future<Response<dynamic>> Function() request) async {
    if (!await networkInfo.isConnected) {
      throw const NetworkException();
    }
    try {
      final response = await request();
      return response.data as T;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
