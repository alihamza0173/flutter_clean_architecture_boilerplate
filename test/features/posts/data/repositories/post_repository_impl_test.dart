import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/errors/exceptions.dart';
import 'package:flutter_clean_architecture/core/errors/failures.dart';
import 'package:flutter_clean_architecture/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/posts/data/models/post_model.dart';
import 'package:flutter_clean_architecture/features/posts/domain/entities/post_entity.dart';
import 'package:flutter_clean_architecture/features/posts/data/repositories/post_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostRemoteDataSource extends Mock implements PostRemoteDataSource {}

void main() {
  late MockPostRemoteDataSource remoteDataSource;
  late PostRepositoryImpl repository;

  setUp(() {
    remoteDataSource = MockPostRemoteDataSource();
    repository = PostRepositoryImpl(remoteDataSource: remoteDataSource);
  });

  const post = PostModel(id: 1, userId: 7, title: 'A title', body: 'A body');

  test('returns Right with the posts on success', () async {
    when(() => remoteDataSource.getPosts()).thenAnswer((_) async => [post]);

    final result = await repository.getPosts();

    expect(result.isRight(), isTrue);
    expect(result.getOrElse(() => []), const [post]);
  });

  test('maps UnauthorizedException to AuthFailure', () async {
    when(
      () => remoteDataSource.getPosts(),
    ).thenThrow(const UnauthorizedException('Token expired'));

    final result = await repository.getPosts();

    expect(result, const Left<Failure, List<PostEntity>>(
      AuthFailure('Token expired'),
    ));
  });

  test('maps NetworkException to NetworkFailure', () async {
    when(() => remoteDataSource.getPosts()).thenThrow(const NetworkException());

    final result = await repository.getPosts();

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<NetworkFailure>(),
    );
  });

  test('maps ServerException to ServerFailure', () async {
    when(
      () => remoteDataSource.getPosts(),
    ).thenThrow(const ServerException('Boom', 500));

    final result = await repository.getPosts();

    expect(result, const Left<Failure, List<PostEntity>>(ServerFailure('Boom')));
  });

  test('getPostById maps failures the same way', () async {
    when(
      () => remoteDataSource.getPostById(1),
    ).thenThrow(const UnauthorizedException());

    final result = await repository.getPostById(1);

    expect(result.fold((failure) => failure, (_) => null), isA<AuthFailure>());
  });
}
