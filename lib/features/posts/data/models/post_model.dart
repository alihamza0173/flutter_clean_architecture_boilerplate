import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/post_entity.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
abstract class PostModel with _$PostModel implements PostEntity {
  const PostModel._();

  const factory PostModel({
    required int id,
    required int userId,
    required String title,
    required String body,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  @override
  List<Object?> get props => [id, userId, title, body];

  @override
  bool? get stringify => true;
}
