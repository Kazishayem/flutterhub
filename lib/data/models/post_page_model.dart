import 'post_model.dart';

class PostPageModel {
  final List<PostModel> posts;
  final int total;
  final int skip;
  final int limit;

  PostPageModel({
    required this.posts,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory PostPageModel.fromJson(Map<String, dynamic> json) {
    final rawPosts = (json['posts'] as List<dynamic>? ?? []);

    return PostPageModel(
      posts:
          rawPosts
              .map((item) => PostModel.fromJson(item as Map<String, dynamic>))
              .toList(),
      total: json['total'] as int? ?? 0,
      skip: json['skip'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
    );
  }
}
