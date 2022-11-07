import 'package:ask_it/controller/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logout(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
              radius: 50,
            ),
            const SizedBox(height: 10),
            Text(
              'u/${user.name}',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            ListTile(
              title: const Text('My Profile'),
              leading: const Icon(FontAwesomeIcons.person),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Log Out'),
              leading: const Icon(Icons.logout),
              onTap: () => logout(ref),
            ),
            Switch.adaptive(
              value: true, 
              onChanged: (val) {},
            ),
          ],
        ),
      ),
    );
  }
}