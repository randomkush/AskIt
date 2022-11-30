import 'package:ask_it/controller/auth.dart';
import 'package:ask_it/pages/common/error.dart';
import 'package:ask_it/pages/common/loader.dart';
import 'package:ask_it/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uid;
  const UserProfileScreen({
    super.key,
    required this.uid,
  });

  void navigateToEditProfile(BuildContext context) {
    Routemaster.of(context).push('/edit-profile/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(getUserDataProvider(uid)).when(
        data: (user) => NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 250,
                floating: true,
                snap: true,
                flexibleSpace: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        user!.banner,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.all(20).copyWith(bottom: 70),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user.profilePic),
                        radius: 35,
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.all(20),
                      child: OutlinedButton(
                        onPressed: () => navigateToEditProfile(context),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Pallete.greyColor.withOpacity(0.15),
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                        ), 
                        child: const Text('Edit Profile'),
                      ),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'u/${user.name}',
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        'TODO followers',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 2),
                  ]),
                ),
              ),
            ];
          }, 
          body: const Text('Displaying Posts'),
        ), 
        error: (error, stackTrace) => ErrorText(
          error: error.toString()
        ), 
        loading: () => const Loader(),
      ),
    ); 
  }
}