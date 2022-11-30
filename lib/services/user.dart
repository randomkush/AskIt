import 'package:ask_it/core/constants/firebase.dart';
import 'package:ask_it/core/failure.dart';
import 'package:ask_it/core/providers/firebase.dart';
import 'package:ask_it/core/typedefs.dart';
import 'package:ask_it/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final userServicesProvider = Provider((ref) {
  return UserServices(firestore: ref.watch(firestoreProvider));
});

class UserServices {
  final FirebaseFirestore _firestore;
  UserServices({
    required FirebaseFirestore firestore
  }): _firestore = firestore;

  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);
  
  FutureVoid editProfile(UserModel user) async {
    try {
      return right(_users.doc(user.uid).update(user.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}