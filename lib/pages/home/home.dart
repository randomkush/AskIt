import 'package:ask_it/controller/auth.dart';
import 'package:ask_it/pages/delegates/search_community.dart';
import 'package:ask_it/pages/home/drawer/community_list.dart';
import 'package:ask_it/pages/home/drawer/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
      drawer: const CommuntiyListDrawer(),
      endDrawer: const ProfileDrawer(),
      appBar: AppBar(
        title: const Center(child: Text('Home')),
        centerTitle: false,
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () => displayDrawer(context), 
            icon: const Icon(Icons.menu),
          );
        }),
        actions: [
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.magnifyingGlass,
              size: 20,
            ),
            onPressed: () {
              showSearch(
                context: context, 
                delegate: SearchCommunityDelegate(ref),
              );
            },
          ),
          Builder(
            builder: (context) {
              return IconButton(
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePic),
                ),
                onPressed: () => displayEndDrawer(context),
              );
            }
          )
        ],
      ),
    );
  }
}
