import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import '../screens/screens.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: const [GestureType.onTap, GestureType.onPanUpdateDownDirection],
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AnimatedEntrance(
                    index: 0,
                    child: AuthHero(icon: FontAwesomeIcons.locationDot),
                  ),
                  const SizedBox(height: 24),
                  AnimatedEntrance(
                    index: 1,
                    child: Text(
                      'Welcome Back',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(height: 6),
                  AnimatedEntrance(
                    index: 2,
                    child: Text(
                      'Sign in to mark your attendance',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  AnimatedEntrance(
                    index: 3,
                    child: AppTextField(
                      controller: emailController,
                      label: 'Email',
                      icon: FontAwesomeIcons.envelope,
                      keyboardType: TextInputType.emailAddress,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z@._-]")),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedEntrance(
                    index: 4,
                    child: AppTextField(
                      controller: passwordController,
                      label: 'Password',
                      icon: FontAwesomeIcons.lock,
                      obscureText: true,
                      maxLength: 12,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () =>
                          goTo(context, const ForgotPasswordPage()),
                      child: const Text('Forgot Password?'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimatedEntrance(
                    index: 5,
                    child: PrimaryButton(
                      label: 'Login',
                      icon: FontAwesomeIcons.rightToBracket,
                      onPressed: () async {
                        final shouldNavigate = await login(context,
                            emailController.text, passwordController.text);
                        if (shouldNavigate && context.mounted) {
                          goFront(context, const MyHomePage());
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedEntrance(
                    index: 6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () =>
                              goFront(context, const RegisterPage()),
                          child: const Text('Register'),
                        ),
                      ],
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
