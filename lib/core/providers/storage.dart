import 'dart:io';

import 'package:ask_it/core/failure.dart';
import 'package:ask_it/core/providers/firebase.dart';
import 'package:ask_it/core/typedefs.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final storageServicesProvider = Provider(
  (ref) => StorageServices(
    firebaseStorage: ref.watch(storageProvider),
  )
);

class StorageServices {
  final FirebaseStorage _firebaseStorage;

  StorageServices({
    required FirebaseStorage firebaseStorage,
  }) : _firebaseStorage= firebaseStorage;

  FutureEither<String> storeFile({required String path, required String id, required File? file}) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);

      UploadTask uploadTask = ref.putFile(file!);

      final snapshot = await uploadTask;

      return right(await snapshot.ref.getDownloadURL());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}