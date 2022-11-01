import 'package:ask_it/controller/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerScreen extends ConsumerWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Drawer(
      child: ListView(
        children: [
          ListTile(
            tileColor: const Color.fromARGB(255, 253, 220, 121),
            textColor: const Color.fromARGB(255, 2, 83, 149),
            iconColor: const Color.fromARGB(255, 2, 83, 149),
            leading: const Icon(
              FontAwesomeIcons.userGroup,
              size: 20,
            ),
            title: const Text('Communities'),
            dense: true,
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            selectedColor: Colors.grey[600],
            tileColor: Colors.grey[200],
            textColor: Colors.black,
            iconColor: Colors.black,
            leading: const Icon(
              FontAwesomeIcons.plus,
              size: 20,
            ),
            title: const Text('Create a community'),
            dense: true,
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: const Icon(
              FontAwesomeIcons.football,
              size: 20,
            ),
            title: const Text('Football'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: const Icon(
              FontAwesomeIcons.userNinja,
              size: 20,
            ),
            title: const Text('Anime'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ],
      ),
    );
  }
}
