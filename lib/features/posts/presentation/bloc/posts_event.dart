import 'package:equatable/equatable.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object?> get props => [];
}

class PostsRequested extends PostsEvent {
  const PostsRequested();
}

class PostDetailRequested extends PostsEvent {
  final int id;

  const PostDetailRequested(this.id);

  @override
  List<Object?> get props => [id];
}
