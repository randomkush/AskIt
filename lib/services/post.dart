import 'package:ask_it/core/constants/firebase.dart';
import 'package:ask_it/core/failure.dart';
import 'package:ask_it/core/providers/firebase.dart';
import 'package:ask_it/core/typedefs.dart';
import 'package:ask_it/models/community.dart';
import 'package:ask_it/models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final postServicesProvider = Provider((ref) {
  return PostServices(firestore: ref.watch(firestoreProvider));
});

class PostServices {
  final FirebaseFirestore _firestore;
  PostServices({
    required FirebaseFirestore firestore
  }): _firestore = firestore;

  CollectionReference get _posts => _firestore.collection(FirebaseConstants.postsCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    return _posts
      .where(
        'communityName', 
        whereIn: communities.map((e) => e.name).toList(),
      )
      .orderBy(
        'createdAt', 
        descending: true,
      )
      .snapshots()
      .map(
        (event) => event.docs
          .map(
            (e) => Post.fromMap(
              e.data() as Map<String,dynamic>,
            ),
          )
        .toList(),
      );
  } 
}