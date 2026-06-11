import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import '../screens/screens.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: const [GestureType.onTap, GestureType.onPanUpdateDownDirection],
      child: Scaffold(
        appBar: AppBar(title: const Text('Reset Password')),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AnimatedEntrance(
                    index: 0,
                    child: AuthHero(icon: FontAwesomeIcons.key),
                  ),
                  const SizedBox(height: 28),
                  AnimatedEntrance(
                    index: 1,
                    child: Text(
                      'Forgot your password?',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedEntrance(
                    index: 2,
                    child: Text(
                      'Enter your email and we will send you a reset link.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  AnimatedEntrance(
                    index: 3,
                    child: AppTextField(
                      controller: emailController,
                      label: 'Email',
                      icon: FontAwesomeIcons.envelope,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp("[0-9a-zA-Z@._-]")),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  AnimatedEntrance(
                    index: 4,
                    child: PrimaryButton(
                      label: 'Send Reset Link',
                      icon: FontAwesomeIcons.paperPlane,
                      onPressed: () async {
                        await resetPassword(context, emailController.text);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
