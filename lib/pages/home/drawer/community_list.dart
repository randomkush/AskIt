import 'package:ask_it/controller/auth.dart';
import 'package:ask_it/controller/community.dart';
import 'package:ask_it/pages/common/error.dart';
import 'package:ask_it/pages/common/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:routemaster/routemaster.dart';

class CommuntiyListDrawer extends ConsumerWidget {
  const CommuntiyListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: const Text('Create a community'),
              leading: const Icon(FontAwesomeIcons.plus),
              onTap: () => navigateToCreateCommunity(context),
            ),
            
            ref.watch(userCommunitiesProvider).when(
              data: (communities) => Expanded(
                child: ListView.builder(
                  itemCount: communities.length,
                  itemBuilder: (BuildContext context, int index) {
                    final community = communities[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(community.avatar),
                      ),
                      title: Text('r/${community.name}'),
                      onTap: () {},
                    );
                  },
                ),
              ), 
              error: (error, stackTrace) => ErrorText(
                error: error.toString()
              ), 
              loading: () => const Loader(),
            ),
          ],
        ),
      ),
    );
  }
}
