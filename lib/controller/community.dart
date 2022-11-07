import 'dart:io';

import 'package:ask_it/controller/auth.dart';
import 'package:ask_it/core/constants/constants.dart';
import 'package:ask_it/core/failure.dart';
import 'package:ask_it/core/providers/storage.dart';
import 'package:ask_it/core/typedefs.dart';
import 'package:ask_it/core/utils.dart';
import 'package:ask_it/models/community.dart';
import 'package:ask_it/services/community.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:routemaster/routemaster.dart';

final userCommunitiesProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});

final communityControllerProvider = StateNotifierProvider<CommunityController, bool>((ref) {
  final communityServices = ref.watch(communityServicesProvider);
  final storageServices = ref.watch(storageServicesProvider);
  return CommunityController(
    communityServices: communityServices, 
    storageServices: storageServices,
    ref: ref
  );
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref.watch(communityControllerProvider.notifier).getCommunityByName(name);
});

final searchCommunityProvider = StreamProvider.family((ref, String query) {
  return ref.watch(communityControllerProvider.notifier).searchCommunity(query);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityServices _communityServices;
  final StorageServices _storageServices;
  final Ref _ref;
  CommunityController({
    required CommunityServices communityServices,
    required Ref ref,
    required StorageServices storageServices
  }): _communityServices = communityServices,
      _storageServices = storageServices,
      _ref = ref,
      super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';

    Community community = Community(
      id: name,
      name: name, 
      banner: Constants.bannerDefault, 
      avatar: Constants.avatarDefault, 
      members: [uid], 
      mods: [uid],
    );

    final res = await _communityServices.createCommunity(community);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Community created succesfully!');
        Routemaster.of(context).pop();
      }
    );
  } 

  void joinCommunity(Community community, BuildContext context) async {
    final user = _ref.read(userProvider)!;
    
    Either<Failure, void> res;
    if (community.members.contains(user.uid)) {
      res = await _communityServices.leaveCommunity(community.name, user.uid);
    } else {
      res = await _communityServices.joinCommunity(community.name, user.uid);
    }

    res.fold(
      (l) => showSnackBar(context, l.message), 
      (r) {
        if (community.members.contains(user.uid)) {
          showSnackBar(context, 'Community Left Successfully!');
        } else {
          showSnackBar(context, 'Community Joined Successfully!');
        }
      },
    );
  }

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityServices.getUserCommunities(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityServices.getCommunityByName(name);
  } 

  void editCommunity({
    required File? profileFile, 
    required File? bannerFile, 
    required Community community,
    required BuildContext context,
  }) async {
    state = true;
    if (profileFile != null) {
      final res = await _storageServices.storeFile(
        path: 'communities/profile', 
        id: community.name, 
        file: profileFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.message), 
        (r) => community = community.copyWith(avatar: r),
      );
    }
    if (bannerFile != null) {
      final res = await _storageServices.storeFile(
        path: 'communities/banner', 
        id: community.name, 
        file: bannerFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.message), 
        (r) => community = community.copyWith(banner: r),
      );
    }

    final res = await _communityServices.editCommunity(community);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message), 
      (r) => Routemaster.of(context).pop(),
    );
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityServices.searchCommunity(query);
  }
}