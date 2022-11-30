import 'dart:io';

import 'package:ask_it/controller/auth.dart';
import 'package:ask_it/controller/user.dart';
import 'package:ask_it/core/constants/constants.dart';
import 'package:ask_it/core/utils.dart';
import 'package:ask_it/pages/common/error.dart';
import 'package:ask_it/pages/common/loader.dart';
import 'package:ask_it/theme/theme.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileScreen({
    super.key,
    required this.uid,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? bannerFile;
  File? profileFile;

  void selectBannerImage() async {
    final res = await pickImage();

    if(res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();

    if(res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save() {
    ref.read(userControllerProvider.notifier).editProfile(
      bannerFile: bannerFile, 
      profileFile: profileFile, 
      context: context
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userControllerProvider);
    return ref.watch(getUserDataProvider(widget.uid)).when(
      data: (user) => Scaffold(
        backgroundColor: Pallete.darkModeAppTheme.backgroundColor,
        appBar: AppBar(
          title: const Text('Edit Profile'),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: save, 
              icon: const Icon(FontAwesomeIcons.floppyDisk),
            ),
          ],
        ),
        body: isLoading
          ? const Loader()
          : Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: selectBannerImage,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(10),
                        dashPattern: const [10, 4],
                        strokeCap: StrokeCap.round,
                        color: Pallete.darkModeAppTheme.textTheme.bodyText2!.color!,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: bannerFile != null 
                            ? Image.file(bannerFile!)
                            : user!.banner.isEmpty || user.banner == Constants.bannerDefault
                              ? const Center(
                                child: Icon(
                                  FontAwesomeIcons.camera,
                                  size: 30,
                                ),
                              )
                              : Image.network(user.banner),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: GestureDetector(
                        onTap: selectProfileImage,
                        child: profileFile != null 
                          ? CircleAvatar(
                            backgroundImage: FileImage(profileFile!),
                            radius: 32,
                          )
                          : CircleAvatar(
                            backgroundImage: NetworkImage(user!.profilePic),
                            radius: 32,
                          ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ), 
      error: (error, stackTrace) => ErrorText(
        error: error.toString()
      ), 
      loading: () => const Loader(),
    );
  }
}