import 'package:ask_it/constants/constants.dart';
import 'package:ask_it/controller/auth.dart';
import 'package:ask_it/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInWithGoogle(WidgetRef ref) {
    ref.read(authControllerProvider).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              Constants.logoPath,
            ),
            Flexible(
              child: LoginButton(
                icon: FontAwesomeIcons.userNinja,
                color: Pallete.deepPurple,
                text: 'Continue as Guest',
                loginMethod: () => {},
              ),
            ),
            Flexible(
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton.icon(
                  icon: const Icon(
                    FontAwesomeIcons.google,
                    color: Pallete.whiteColor,
                    size: 20,
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(24),
                    backgroundColor: Pallete.blueColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () => signInWithGoogle(ref),
                  label: const Text('Sign in with Google', textAlign: TextAlign.center),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LoginButton extends ConsumerWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function loginMethod;

  const LoginButton({
    super.key,
    required this.color,
    required this.icon,
    required this.text,
    required this.loginMethod,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton.icon(
        icon: Icon(
          icon,
          color: Pallete.whiteColor,
          size: 20,
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(24),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () => loginMethod,
        label: Text(text, textAlign: TextAlign.center),
      ),
    );
  }
}