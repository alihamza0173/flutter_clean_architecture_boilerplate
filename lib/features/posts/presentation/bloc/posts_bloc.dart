import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_post_by_id_usecase.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import 'posts_event.dart';
import 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetPostsUseCase getPostsUseCase;
  final GetPostByIdUseCase getPostByIdUseCase;

  PostsBloc({required this.getPostsUseCase, required this.getPostByIdUseCase})
    : super(const PostsInitial()) {
    on<PostsRequested>(_onPostsRequested);
    on<PostDetailRequested>(_onPostDetailRequested);
  }

  Future<void> _onPostsRequested(
    PostsRequested event,
    Emitter<PostsState> emit,
  ) async {
    emit(const PostsLoading());
    final result = await getPostsUseCase();
    result.fold(
      (failure) => emit(PostsError(failure.message)),
      (posts) => emit(PostsLoaded(posts)),
    );
  }

  Future<void> _onPostDetailRequested(
    PostDetailRequested event,
    Emitter<PostsState> emit,
  ) async {
    emit(const PostsLoading());
    final result = await getPostByIdUseCase(id: event.id);
    result.fold(
      (failure) => emit(PostsError(failure.message)),
      (post) => emit(PostDetailLoaded(post)),
    );
  }
}
