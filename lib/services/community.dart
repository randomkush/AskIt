import 'package:ask_it/core/constants/firebase.dart';
import 'package:ask_it/core/failure.dart';
import 'package:ask_it/core/providers/firebase.dart';
import 'package:ask_it/core/typedefs.dart';
import 'package:ask_it/models/community.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final communityServicesProvider = Provider((ref) {
  return CommunityServices(firestore: ref.watch(firestoreProvider));
});

class CommunityServices {
  final FirebaseFirestore _firestore;
  CommunityServices({
    required FirebaseFirestore firestore
  }): _firestore = firestore;

  FutureVoid createCommunity(Community community) async {
    try {
      var communityDoc = await _communities.doc(community.name).get();
      if(communityDoc.exists) {
        throw 'Community with the same name already exists!';
      }

      return right(_communities.doc(community.name).set(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> getUserCommunities(String uid) {
    return _communities.where('members', arrayContains: uid).snapshots().map((event) {
      List<Community> communities = [];
      for (var doc in event.docs) {
        communities.add(Community.fromMap(doc.data() as Map<String, dynamic>));
      }
      return communities; 
    });
  }

  CollectionReference get _communities => _firestore.collection(FirebaseConstants.communitiesCollection);
}