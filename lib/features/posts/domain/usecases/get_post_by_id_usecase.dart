import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class GetPostByIdUseCase {
  final PostRepository repository;

  GetPostByIdUseCase(this.repository);

  Future<Either<Failure, PostEntity>> call({required int id}) {
    return repository.getPostById(id);
  }
}
