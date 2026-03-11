import '../models/post_page_model.dart';
import '../sources/remote/post_api_service.dart';

class PostRepository {
  final PostApiService remoteSource;

  PostRepository({required this.remoteSource});

  Future<PostPageModel> fetchPosts({required int limit, required int skip}) {
    return remoteSource.fetchPosts(limit: limit, skip: skip);
  }
}
