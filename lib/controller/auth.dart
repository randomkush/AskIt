import 'package:ask_it/services/auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = Provider((ref) => AuthController(authServices: ref.read(authServicesProvider)));

class AuthController {
  final AuthServices _authServices;
  AuthController({required AuthServices authServices}): _authServices = authServices;

  void signInWithGoogle() {
    _authServices.signInWithGoogle();
  }
}