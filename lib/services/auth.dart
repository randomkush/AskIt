import 'package:ask_it/providers/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authServicesProvider = Provider(
  (ref) => AuthServices(
    firestore: ref.read(firestoreProvider), 
    auth: ref.read(authProvider), 
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthServices {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthServices({
    required FirebaseFirestore firestore, 
    required FirebaseAuth auth, 
    required GoogleSignIn googleSignIn,
  }): _auth = auth,
      _firestore = firestore, 
      _googleSignIn = googleSignIn;

  void signInWithGoogle() async {
    try {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        final googleAuth = await googleUser?.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        UserCredential userCredential = await _auth.signInWithCredential(credential);

        print(userCredential.user?.email);
    } catch (e) {
      print(e.toString());
    }
  }
}