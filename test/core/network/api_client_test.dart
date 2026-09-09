import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/core/errors/exceptions.dart';
import 'package:flutter_clean_architecture/core/network/api_client.dart';
import 'package:flutter_clean_architecture/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockDio dio;
  late MockNetworkInfo networkInfo;
  late DioApiClient apiClient;

  setUp(() {
    dio = MockDio();
    networkInfo = MockNetworkInfo();
    apiClient = DioApiClient(dio: dio, networkInfo: networkInfo);
  });

  Response<dynamic> okResponse(Object? data) {
    return Response<dynamic>(
      requestOptions: RequestOptions(path: '/posts'),
      statusCode: 200,
      data: data,
    );
  }

  test('throws NetworkException without calling Dio when offline', () async {
    when(() => networkInfo.isConnected).thenAnswer((_) async => false);

    expect(
      () => apiClient.get<List<dynamic>>('/posts'),
      throwsA(isA<NetworkException>()),
    );
    verifyNever(
      () => dio.get<dynamic>(
        '/posts',
      ),
    );
  });

  test('returns the decoded response body when online', () async {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
    when(
      () => dio.get<dynamic>(
        '/posts',
      ),
    ).thenAnswer((_) async => okResponse([1, 2, 3]));

    final result = await apiClient.get<List<dynamic>>('/posts');

    expect(result, [1, 2, 3]);
  });

  test('converts a DioException into the project exception type', () async {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
    when(
      () => dio.get<dynamic>(
        '/posts',
      ),
    ).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/posts'),
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: RequestOptions(path: '/posts'),
          statusCode: 401,
        ),
      ),
    );

    await expectLater(
      apiClient.get<List<dynamic>>('/posts'),
      throwsA(isA<UnauthorizedException>()),
    );
  });

  test('post forwards the body and returns decoded data', () async {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
    when(
      () => dio.post<dynamic>(
        '/posts',
        data: {'title': 'hello'},
      ),
    ).thenAnswer((_) async => okResponse({'id': 1}));

    final result = await apiClient.post<Map<String, dynamic>>(
      '/posts',
      data: {'title': 'hello'},
    );

    expect(result, {'id': 1});
  });
}
