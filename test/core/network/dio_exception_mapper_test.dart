import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/core/errors/exceptions.dart';
import 'package:flutter_clean_architecture/core/network/dio_exception_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final requestOptions = RequestOptions(path: '/posts');

  DioException dioError(DioExceptionType type, {Response<dynamic>? response}) {
    return DioException(
      requestOptions: requestOptions,
      type: type,
      response: response,
    );
  }

  Response<dynamic> responseWith(int statusCode, {Object? data}) {
    return Response<dynamic>(
      requestOptions: requestOptions,
      statusCode: statusCode,
      data: data,
    );
  }

  group('mapDioException', () {
    test('maps every timeout type to NetworkException', () {
      for (final type in const [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
      ]) {
        final result = mapDioException(dioError(type));
        expect(result, isA<NetworkException>());
        expect((result as NetworkException).message, 'Connection timed out');
      }
    });

    test('maps connectionError to NetworkException', () {
      expect(
        mapDioException(dioError(DioExceptionType.connectionError)),
        isA<NetworkException>(),
      );
    });

    test('maps cancel and badCertificate to ServerException', () {
      expect(
        mapDioException(dioError(DioExceptionType.cancel)),
        isA<ServerException>(),
      );
      expect(
        mapDioException(dioError(DioExceptionType.badCertificate)),
        isA<ServerException>(),
      );
    });

    test('maps 401 and 403 to UnauthorizedException', () {
      for (final code in const [401, 403]) {
        final result = mapDioException(
          dioError(
            DioExceptionType.badResponse,
            response: responseWith(code),
          ),
        );
        expect(result, isA<UnauthorizedException>());
      }
    });

    test('maps other bad responses to ServerException with status code', () {
      final result = mapDioException(
        dioError(
          DioExceptionType.badResponse,
          response: responseWith(500),
        ),
      );
      expect(result, isA<ServerException>());
      expect((result as ServerException).statusCode, 500);
      expect(result.message, 'Request failed with status 500');
    });

    test('extracts the server-provided message from the body', () {
      final result = mapDioException(
        dioError(
          DioExceptionType.badResponse,
          response: responseWith(422, data: {'message': 'Title is required'}),
        ),
      );
      expect((result as ServerException).message, 'Title is required');
      expect(result.statusCode, 422);
    });

    test('falls back through message, error and detail keys', () {
      expect(messageFromResponseBody({'error': 'boom'}), 'boom');
      expect(messageFromResponseBody({'detail': 'nope'}), 'nope');
      expect(messageFromResponseBody({'other': 'ignored'}), isNull);
      expect(messageFromResponseBody('not a map'), isNull);
      expect(messageFromResponseBody(null), isNull);
    });
  });
}
