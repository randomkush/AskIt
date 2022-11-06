import 'package:ask_it/controller/auth.dart';
import 'package:ask_it/core/constants/constants.dart';
import 'package:ask_it/core/utils.dart';
import 'package:ask_it/models/community.dart';
import 'package:ask_it/services/community.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

final userCommunitiesProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});

final communityControllerProvider = StateNotifierProvider<CommunityController, bool>((ref) {
  final communityServices = ref.watch(communityServicesProvider);
  return CommunityController(
    communityServices: communityServices, 
    ref: ref
  );
});

class CommunityController extends StateNotifier<bool> {
  final CommunityServices _communityServices;
  final Ref _ref;
  CommunityController({
    required CommunityServices communityServices,
    required Ref ref,
  }): _communityServices = communityServices,
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

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityServices.getUserCommunities(uid);
  }
}