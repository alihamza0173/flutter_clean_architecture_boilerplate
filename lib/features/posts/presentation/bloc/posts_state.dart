import 'package:equatable/equatable.dart';
import '../../domain/entities/post_entity.dart';

sealed class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object?> get props => [];
}

class PostsInitial extends PostsState {
  const PostsInitial();
}

class PostsLoading extends PostsState {
  const PostsLoading();
}

class PostsLoaded extends PostsState {
  final List<PostEntity> posts;

  const PostsLoaded(this.posts);

  @override
  List<Object?> get props => [posts];
}

class PostDetailLoaded extends PostsState {
  final PostEntity post;

  const PostDetailLoaded(this.post);

  @override
  List<Object?> get props => [post];
}

class PostsError extends PostsState {
  final String message;

  const PostsError(this.message);

  @override
  List<Object?> get props => [message];
}
