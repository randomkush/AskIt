import 'package:ask_it/controller/community.dart';
import 'package:ask_it/pages/common/loader.dart';
import 'package:ask_it/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    communityNameController.dispose();
  }

  void createCommunity() {
    ref.read(communityControllerProvider.notifier).createCommunity(
      communityNameController.text.trim(), 
      context
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
     
    return isLoading ?
      const Loader() :
      Scaffold(
        appBar: AppBar(
          title: const Text('Create a Community'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Text('Community Name')
              ),
              const SizedBox(height: 10),
              TextField(
                controller: communityNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter community name',
                  filled: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(18),
                ),
                maxLength: 21,
              ),
              const SizedBox(height: 30),
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      padding: const EdgeInsets.all(24),
                      backgroundColor: Pallete.blueColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: createCommunity,
                    child: const Text('Create Community'),
                  ),
                ),
              )
            ]
          ),
        ),
      );
  }
}