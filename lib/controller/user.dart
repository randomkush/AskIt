// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:ask_it/controller/auth.dart';
import 'package:ask_it/core/utils.dart';
import 'package:ask_it/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ask_it/core/providers/storage.dart';
import 'package:ask_it/services/user.dart';
import 'package:routemaster/routemaster.dart';

final userControllerProvider = StateNotifierProvider<UserController,bool>((ref) {
  final userServices = ref.watch(userServicesProvider);
  final storageServices = ref.watch(storageServicesProvider);
  return UserController(
    userServices: userServices, 
    ref: ref, 
    storageServices: storageServices
  );
});

class UserController extends StateNotifier<bool> {
  final UserServices _userServices;
  final StorageServices _storageServices;
  final Ref _ref;
  UserController({
    required UserServices userServices,
    required Ref ref,
    required StorageServices storageServices,
  }): _userServices = userServices,
      _ref = ref,
      _storageServices = storageServices,
      super(false);
  
  void editProfile({
    required File? bannerFile,
    required File? profileFile,
    required BuildContext context,
  }) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;

    if (profileFile != null) {
      final res = await _storageServices.storeFile(
        path: 'user/profile', 
        id: user.uid, 
        file: profileFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.message), 
        (r) => user = user.copyWith(profilePic: r),
      );
    }

    if (bannerFile != null) {
      final res = await _storageServices.storeFile(
        path: 'user/banner', 
        id: user.uid, 
        file: bannerFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.message), 
        (r) => user = user.copyWith(banner: r),
      );
    }

    final res = await _userServices.editProfile(user);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message), 
      (r) => Routemaster.of(context).pop(),
    );
  }
}
