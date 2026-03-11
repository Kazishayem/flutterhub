import '../../../core/network/api_clients.dart';
import '../../../core/network/api_endpoints.dart';
import '../../models/post_page_model.dart';

class PostApiService {
  final ApiClient apiClient;

  PostApiService({required this.apiClient});

  Future<PostPageModel> fetchPosts({
    required int limit,
    required int skip,
  }) async {
    final dynamic response = await apiClient.getRequest(
      endpoints: '${ApiEndpoints.posts}?limit=$limit&skip=$skip',
    );

    if (response is Map<String, dynamic>) {
      return PostPageModel.fromJson(response);
    }

    throw Exception('Invalid posts response');
  }
}
