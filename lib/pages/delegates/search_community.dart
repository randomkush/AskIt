import 'package:ask_it/controller/community.dart';
import 'package:ask_it/pages/common/error.dart';
import 'package:ask_it/pages/common/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:routemaster/routemaster.dart';

class SearchCommunityDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchCommunityDelegate(this.ref);  

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(FontAwesomeIcons.xmark),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchCommunityProvider(query)).when(
      data: (communities) => ListView.builder(
        itemCount: communities.length,
        itemBuilder: (BuildContext context, int index) {
          final community = communities[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(community.avatar),
            ),
            title: Text('r/${community.name}'),
            onTap: () => navigateToCommunity(context, community.name),
          );
        },
      ), 
      error: (error, stackTrace) => ErrorText(
        error: error.toString()
      ), 
      loading: () => const Loader(),
    );
  }

  void navigateToCommunity(BuildContext context, String communityName) {
    Routemaster.of(context).push('/r/$communityName');
  }
}