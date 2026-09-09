import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/errors/failures.dart';
import 'package:flutter_clean_architecture/features/posts/domain/entities/post_entity.dart';
import 'package:flutter_clean_architecture/features/posts/domain/usecases/get_post_by_id_usecase.dart';
import 'package:flutter_clean_architecture/features/posts/domain/usecases/get_posts_usecase.dart';
import 'package:flutter_clean_architecture/features/posts/presentation/bloc/posts_bloc.dart';
import 'package:flutter_clean_architecture/features/posts/presentation/bloc/posts_event.dart';
import 'package:flutter_clean_architecture/features/posts/presentation/bloc/posts_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPostsUseCase extends Mock implements GetPostsUseCase {}

class MockGetPostByIdUseCase extends Mock implements GetPostByIdUseCase {}

void main() {
  late MockGetPostsUseCase getPostsUseCase;
  late MockGetPostByIdUseCase getPostByIdUseCase;

  setUp(() {
    getPostsUseCase = MockGetPostsUseCase();
    getPostByIdUseCase = MockGetPostByIdUseCase();
  });

  const post = PostEntity(id: 1, userId: 7, title: 'A title', body: 'A body');

  PostsBloc buildBloc() => PostsBloc(
    getPostsUseCase: getPostsUseCase,
    getPostByIdUseCase: getPostByIdUseCase,
  );

  blocTest<PostsBloc, PostsState>(
    'emits [PostsLoading, PostsLoaded] when the posts load',
    setUp: () {
      when(
        () => getPostsUseCase(),
      ).thenAnswer((_) async => const Right([post]));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const PostsRequested()),
    expect: () => const [PostsLoading(), PostsLoaded([post])],
  );

  blocTest<PostsBloc, PostsState>(
    'emits [PostsLoading, PostsError] when the repository fails',
    setUp: () {
      when(() => getPostsUseCase()).thenAnswer(
        (_) async => const Left(ServerFailure('Boom')),
      );
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const PostsRequested()),
    expect: () => const [PostsLoading(), PostsError('Boom')],
  );

  blocTest<PostsBloc, PostsState>(
    'emits [PostsLoading, PostDetailLoaded] for a single post',
    setUp: () {
      when(
        () => getPostByIdUseCase(id: 1),
      ).thenAnswer((_) async => const Right(post));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const PostDetailRequested(1)),
    expect: () => const [PostsLoading(), PostDetailLoaded(post)],
  );

  blocTest<PostsBloc, PostsState>(
    'surfaces a 401 as an AuthFailure message',
    setUp: () {
      when(() => getPostsUseCase()).thenAnswer(
        (_) async => const Left(AuthFailure('Token expired')),
      );
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const PostsRequested()),
    expect: () => const [PostsLoading(), PostsError('Token expired')],
  );
}
