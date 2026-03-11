import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/network/api_clients.dart';
import '../../../data/models/post_model.dart';
import '../../../data/repositories/post_repository.dart';
import '../../../data/sources/remote/post_api_service.dart';

final postRepositoryProvider = Provider<PostRepository>(
  (ref) => PostRepository(remoteSource: PostApiService(apiClient: ApiClient())),
);

final postViewModelProvider = StateNotifierProvider<PostViewModel, PostState>(
  (ref) => PostViewModel(repository: ref.read(postRepositoryProvider)),
);

class PostState {
  final List<PostModel> posts;
  final bool isInitialLoading;
  final bool isPaginationLoading;
  final bool hasMore;
  final String? initialError;
  final String? paginationError;
  final int limit;
  final int skip;

  const PostState({
    required this.posts,
    required this.isInitialLoading,
    required this.isPaginationLoading,
    required this.hasMore,
    required this.initialError,
    required this.paginationError,
    required this.limit,
    required this.skip,
  });

  factory PostState.initial() {
    return const PostState(
      posts: [],
      isInitialLoading: true,
      isPaginationLoading: false,
      hasMore: true,
      initialError: null,
      paginationError: null,
      limit: 10,
      skip: 0,
    );
  }

  PostState copyWith({
    List<PostModel>? posts,
    bool? isInitialLoading,
    bool? isPaginationLoading,
    bool? hasMore,
    String? initialError,
    bool clearInitialError = false,
    String? paginationError,
    bool clearPaginationError = false,
    int? limit,
    int? skip,
  }) {
    return PostState(
      posts: posts ?? this.posts,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isPaginationLoading: isPaginationLoading ?? this.isPaginationLoading,
      hasMore: hasMore ?? this.hasMore,
      initialError:
          clearInitialError ? null : (initialError ?? this.initialError),
      paginationError:
          clearPaginationError
              ? null
              : (paginationError ?? this.paginationError),
      limit: limit ?? this.limit,
      skip: skip ?? this.skip,
    );
  }
}

class PostViewModel extends StateNotifier<PostState> {
  final PostRepository repository;

  PostViewModel({required this.repository}) : super(PostState.initial()) {
    fetchInitialPosts();
  }

  Future<void> fetchInitialPosts() async {
    state = state.copyWith(
      isInitialLoading: true,
      posts: [],
      hasMore: true,
      skip: 0,
      clearInitialError: true,
      clearPaginationError: true,
    );

    try {
      final page = await repository.fetchPosts(limit: state.limit, skip: 0);
      final hasMore = page.posts.length < page.total;

      state = state.copyWith(
        posts: page.posts,
        isInitialLoading: false,
        hasMore: hasMore,
        skip: page.posts.length,
        clearInitialError: true,
      );
    } catch (error) {
      state = state.copyWith(
        isInitialLoading: false,
        initialError: error.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> loadMorePosts() async {
    if (state.isInitialLoading || state.isPaginationLoading || !state.hasMore) {
      return;
    }

    state = state.copyWith(
      isPaginationLoading: true,
      clearPaginationError: true,
    );

    try {
      final page = await repository.fetchPosts(
        limit: state.limit,
        skip: state.skip,
      );

      final updatedPosts = [...state.posts, ...page.posts];
      final hasMore = updatedPosts.length < page.total;

      state = state.copyWith(
        posts: updatedPosts,
        isPaginationLoading: false,
        hasMore: hasMore,
        skip: updatedPosts.length,
        clearPaginationError: true,
      );
    } catch (error) {
      state = state.copyWith(
        isPaginationLoading: false,
        paginationError: error.toString().replaceFirst('Exception: ', ''),
      );
    }
  }
}
