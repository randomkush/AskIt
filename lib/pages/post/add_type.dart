import 'dart:io';

import 'package:ask_it/controller/community.dart';
import 'package:ask_it/controller/post.dart';
import 'package:ask_it/core/utils.dart';
import 'package:ask_it/models/community.dart';
import 'package:ask_it/pages/common/error.dart';
import 'package:ask_it/pages/common/loader.dart';
import 'package:ask_it/theme/theme.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({
    super.key,
    required this.type,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  File? postFile;
  final titleController = TextEditingController();
  final desciptionController = TextEditingController();
  final linkController = TextEditingController();
  List<Community> communities = [];
  Community? selectedCommunity;

  void selectBannerImage() async {
    final res = await pickImage();

    if(res != null) {
      setState(() {
        postFile = File(res.files.first.path!);
      });
    }
  }

  void sharePost() {
    if (widget.type == 'Image' && postFile != null && titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareImagePost(
        context: context, 
        title: titleController.text.trim(), 
        selectedCommunity: selectedCommunity ?? communities[0], 
        imageFile: postFile,
      );
    } else if (widget.type == 'Text' &&  titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
        context: context, 
        title: titleController.text.trim(), 
        selectedCommunity: selectedCommunity ?? communities[0], 
        description: desciptionController.text.trim(),
      );
    } else if (widget.type == 'Link' && titleController.text.isNotEmpty && linkController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
        context: context, 
        title: titleController.text.trim(), 
        selectedCommunity: selectedCommunity ?? communities[0], 
        link: linkController.text.trim(),
      );
    } else {
      showSnackBar(context, 'Please Enter All The Fields');
    }
  }
  
  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    desciptionController.dispose();
    linkController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'Image';
    final isTypeText = widget.type == 'Text';
    final isTypeLink = widget.type == 'Link';
    final currentTheme = ref.watch(themeNotifierProvider);
    final isLoading = ref.watch(postControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.type}'),
        actions: [
          IconButton(
            onPressed: sharePost, 
            icon: const Icon(FontAwesomeIcons.share),
          ),
        ],
      ),
      body: isLoading 
        ? const Loader() 
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    filled: true,
                    hintText: 'Enter Title Here',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(18),
                  ),
                  maxLength: 50,
                ),
                const SizedBox(height: 10),
                if (isTypeImage) 
                  GestureDetector(
                    onTap: selectBannerImage,
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(10),
                      dashPattern: const [10, 4],
                      strokeCap: StrokeCap.round,
                      color: currentTheme.textTheme.bodyText2!.color!,
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: postFile != null 
                          ? Image.file(postFile!)
                          : const Center(
                              child: Icon(
                                FontAwesomeIcons.camera,
                                size: 30,
                              ),
                            ),
                      ),
                    ),
                  ),
                if (isTypeText)
                  TextField(
                    controller: desciptionController,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Enter Description Here',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18),
                    ),
                    maxLines: 7,
                  ),
                if (isTypeLink)
                  TextField(
                    controller: linkController,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Enter Link Here',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18),
                    ),
                  ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text('Select Community'),
                ),

                ref.watch(userCommunitiesProvider).when(
                  data: (data) {
                    communities = data;

                    if (data.isEmpty) {
                      return const SizedBox();
                    }

                    return DropdownButton(
                      value: selectedCommunity ?? data[0], 
                      items: data.map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.name),
                      )).toList(), 
                      onChanged: (val) {
                        setState(() {
                          selectedCommunity = val;
                        });
                      },
                    );
                  },
                  error: (error, stackTrace) => ErrorText(
                    error: error.toString(),
                  ), 
                  loading: () => const Loader(),
                ),
              ],
            ),
          ),
    );
  }
}