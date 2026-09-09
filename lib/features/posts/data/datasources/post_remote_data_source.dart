import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getPosts();

  Future<PostModel> getPostById(int id);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final ApiClient apiClient;

  PostRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<PostModel>> getPosts() async {
    final data = await apiClient.get<List<dynamic>>(ApiEndpoints.posts);
    return data
        .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PostModel> getPostById(int id) async {
    final data = await apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.post(id),
    );
    if (data.isEmpty) {
      throw const ServerException('Post not found');
    }
    return PostModel.fromJson(data);
  }
}
