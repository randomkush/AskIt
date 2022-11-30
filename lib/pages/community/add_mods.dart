import 'package:ask_it/controller/auth.dart';
import 'package:ask_it/controller/community.dart';
import 'package:ask_it/pages/common/error.dart';
import 'package:ask_it/pages/common/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  final String name;
  const AddModsScreen({
    super.key,
    required this.name
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  Set<String> uids = {};
  int count = 0;

  void addUids(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeUids(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  void saveMods() {
    ref.read(communityControllerProvider.notifier)
      .addMods(
        widget.name, 
        uids.toList(), 
        context,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Moderators'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: saveMods, 
            icon: const Icon(FontAwesomeIcons.floppyDisk),
          ),
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name)).when(
        data: (community) => ListView.builder(
          itemCount: community.members.length,
          itemBuilder: (BuildContext context, int index) {
            final member = community.members[index];

            return ref.watch(getUserDataProvider(member)).when(
              data: (user) { 
                if (count == 0) {
                  for (String mod in community.mods) {
                    uids.add(mod);
                  }
                }
                count++;
                return CheckboxListTile(
                  value: uids.contains(user!.uid), 
                  onChanged: (val) {
                    if (val!) {
                      addUids(user.uid);
                    } else {
                      removeUids(user.uid);
                    }
                  },
                  title: Text(user.name),
                );
              },
              error: (error, stackTrace) => ErrorText(
                error: error.toString()
              ), 
              loading: () => const Loader(),
            );
          },
        ), 
        error: (error, stackTrace) => ErrorText(
          error: error.toString()
        ), 
        loading: () => const Loader(),
      ),
    );
  }
}