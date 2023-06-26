import 'package:ask_it/controller/community.dart';
import 'package:ask_it/controller/post.dart';
import 'package:ask_it/pages/common/error.dart';
import 'package:ask_it/pages/common/loader.dart';
import 'package:ask_it/pages/post/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userCommunitiesProvider).when(
      data: (communities) => ref.watch(userPostsProvider(communities)).when(
        data: (posts) {
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              final post = posts[index];
              return PostCard(post: post) ;
            },
          );
        }, 
        error: (error, stackTrace) => ErrorText(
          error: error.toString()
        ),
        loading: () => const Loader(),
      ),
      error: (error, stackTrace) => ErrorText(
        error: error.toString()
      ),
      loading: () => const Loader(),
    );
  }
}
