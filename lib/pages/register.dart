import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import '../screens/screens.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (passwordController.text != confirmPasswordController.text) {
      await AppDialog.info(
        context,
        title: 'Passwords Did Not Match',
        message: 'Please make sure both passwords are the same.',
        isError: true,
      );
      return;
    }
    final shouldNavigate =
        await register(context, emailController.text, passwordController.text);
    if (shouldNavigate && mounted) {
      await addUser(nameController.text, emailController.text);
      if (mounted) goFront(context, const MyHomePage());
    }
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
                  const SizedBox(height: 20),
                  const AnimatedEntrance(
                    index: 0,
                    child: AuthHero(icon: FontAwesomeIcons.userPlus),
                  ),
                  const SizedBox(height: 24),
                  AnimatedEntrance(
                    index: 1,
                    child: Text(
                      'Create Account',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(height: 28),
                  AnimatedEntrance(
                    index: 2,
                    child: AppTextField(
                      controller: nameController,
                      label: 'Name',
                      icon: FontAwesomeIcons.user,
                      maxLength: 20,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedEntrance(
                    index: 3,
                    child: AppTextField(
                      controller: emailController,
                      label: 'Email',
                      icon: FontAwesomeIcons.envelope,
                      keyboardType: TextInputType.emailAddress,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp("[0-9a-zA-Z@._-]")),
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
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedEntrance(
                    index: 5,
                    child: AppTextField(
                      controller: confirmPasswordController,
                      label: 'Confirm Password',
                      icon: FontAwesomeIcons.lock,
                      obscureText: true,
                      maxLength: 12,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  const SizedBox(height: 28),
                  AnimatedEntrance(
                    index: 6,
                    child: PrimaryButton(
                      label: 'Register',
                      icon: FontAwesomeIcons.userPlus,
                      onPressed: _submit,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedEntrance(
                    index: 7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        TextButton(
                          onPressed: () => goFront(context, const LoginPage()),
                          child: const Text('Login'),
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
