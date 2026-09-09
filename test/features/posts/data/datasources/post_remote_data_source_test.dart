import 'package:flutter_clean_architecture/core/constants/api_endpoints.dart';
import 'package:flutter_clean_architecture/core/errors/exceptions.dart';
import 'package:flutter_clean_architecture/core/network/api_client.dart';
import 'package:flutter_clean_architecture/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient apiClient;
  late PostRemoteDataSourceImpl dataSource;

  setUp(() {
    apiClient = MockApiClient();
    dataSource = PostRemoteDataSourceImpl(apiClient: apiClient);
  });

  const postJson = {
    'id': 1,
    'userId': 7,
    'title': 'A title',
    'body': 'A body',
  };

  test('getPosts decodes the JSON list into models', () async {
    when(
      () => apiClient.get<List<dynamic>>(ApiEndpoints.posts),
    ).thenAnswer((_) async => [postJson]);

    final result = await dataSource.getPosts();

    expect(result, hasLength(1));
    expect(result.first.id, 1);
    expect(result.first.userId, 7);
    expect(result.first.title, 'A title');
    expect(result.first.body, 'A body');
  });

  test('getPostById decodes a single model', () async {
    when(
      () => apiClient.get<Map<String, dynamic>>(ApiEndpoints.post(1)),
    ).thenAnswer((_) async => postJson);

    final result = await dataSource.getPostById(1);

    expect(result.id, 1);
    expect(result.title, 'A title');
  });

  test('getPostById throws ServerException on an empty body', () async {
    when(
      () => apiClient.get<Map<String, dynamic>>(ApiEndpoints.post(99)),
    ).thenAnswer((_) async => <String, dynamic>{});

    expect(
      () => dataSource.getPostById(99),
      throwsA(isA<ServerException>()),
    );
  });

  test('lets exceptions from the client propagate untouched', () async {
    when(
      () => apiClient.get<List<dynamic>>(ApiEndpoints.posts),
    ).thenThrow(const NetworkException());

    expect(() => dataSource.getPosts(), throwsA(isA<NetworkException>()));
  });
}
