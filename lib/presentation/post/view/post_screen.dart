import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterhub/core/resource/constansts/color_manger.dart';
import 'package:flutterhub/presentation/post/view/widget/post_card.dart';
import 'package:flutterhub/presentation/post/viewmodel/post_viewmodel.dart';

class PostScreen extends ConsumerStatefulWidget {
  const PostScreen({super.key});

  @override
  ConsumerState<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState<PostScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final threshold = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.position.pixels >= threshold) {
      ref.read(postViewModelProvider.notifier).loadMorePosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(postViewModelProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(height: 16.h),
              Text(
                'Posts',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 12.h),
              Expanded(child: _buildContent(state)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(PostState state) {
    if (state.isInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.initialError != null && state.posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              state.initialError!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: ColorManager.errorColor),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                ref.read(postViewModelProvider.notifier).fetchInitialPosts();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.posts.isEmpty) {
      return const Center(child: Text('No posts found'));
    }

    final showFooter =
        state.isPaginationLoading || state.paginationError != null;

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(postViewModelProvider.notifier).fetchInitialPosts(),
      child: ListView.separated(
        controller: _scrollController,
        itemCount: state.posts.length + (showFooter ? 1 : 0),
        separatorBuilder: (_, __) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          if (index >= state.posts.length) {
            if (state.isPaginationLoading) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  Text(
                    state.paginationError ?? 'Failed to load more posts',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: ColorManager.errorColor),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      ref.read(postViewModelProvider.notifier).loadMorePosts();
                    },
                    child: const Text('Try again'),
                  ),
                ],
              ),
            );
          }

          final post = state.posts[index];
          return PostCard(post: post);
        },
      ),
    );
  }
}
