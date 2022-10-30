import 'package:ask_it/core/utils.dart';
import 'package:ask_it/models/user.dart';
import 'package:ask_it/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authServices: ref.watch(authServicesProvider),
    ref: ref,
  )
);

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthServices _authServices;
  final Ref _ref;

  AuthController({
    required AuthServices authServices,
    required Ref ref,
  }): _authServices = authServices,
      _ref = ref,
      super(false);

  Stream<User?> get  authStateChange => _authServices.authStateChange;

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await  _authServices.signInWithGoogle();
    state = false;
    user.fold(
      (error) => showSnackBar(context, error.message), 
      (userModel) => _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

  Stream<UserModel?> getUserData(String uid) {
    return _authServices.getUserData(uid);
  }
}