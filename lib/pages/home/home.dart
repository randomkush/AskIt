import 'package:ask_it/controller/auth.dart';
import 'package:ask_it/pages/home/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
      drawer: const DrawerScreen(),
      appBar: AppBar(
        title: const Center(child: Text('Home')),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.searchengin,
              size: 20,
            ),
            onPressed: () {
              // do something
            },
          ),
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.userNinja,
              size: 20,
            ),
            onPressed: () {
              // do something
            },
          )
        ],
      ),
    );
  }
}