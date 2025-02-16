import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import '../../screens/screens.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: KeyboardDismisser(
        gestures: const [
          GestureType.onTap,
          GestureType.onPanUpdateDownDirection
        ],
        child: CupertinoPageScaffold(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 200,
                    width: 200,
                    child: Image(
                      image: AssetImage(
                        'assets/images/login.png',
                      ),
                    ),
                  ),
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 40,
                    width: 350,
                    child: CupertinoTextField(
                      controller: emailController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9a-z@.]")),
                      ],
                      placeholder: 'Email',
                      prefix: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(CupertinoIcons.mail,
                            size: 23, color: CupertinoColors.systemGrey),
                        onPressed: () {
                          goTo(context, const ProfilePage());
                        },
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 40,
                    width: 350,
                    child: CupertinoTextField(
                      controller: passwordController,
                      placeholder: 'Password',
                      prefix: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(CupertinoIcons.lock,
                            size: 23, color: CupertinoColors.systemGrey),
                        onPressed: () {
                          goTo(context, const ProfilePage());
                        },
                      ),
                      obscureText: true,
                      maxLength: 12,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) {
                        debugPrint(value);
                      },
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 50,
                    width: 180,
                    child: CupertinoButton(
                      color: CupertinoColors.systemPink,
                      onPressed: () async {
                        bool shouldNavigate = await login(context,
                            emailController.text, passwordController.text);
                        if (shouldNavigate) {
                          // ignore: use_build_context_synchronously
                          goFront(context, const MyHomePage());
                        }
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: const Text('Login'),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: GestureDetector(
                      onTap: () {
                        goTo(context, const ForgotPasswordPage());
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                            fontSize: 15, color: CupertinoColors.systemGrey),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: GestureDetector(
                      onTap: () {
                        goFront(context, const RegisterPage());
                      },
                      child: const Text(
                        'Dont have an Account? Register',
                        style: TextStyle(
                            fontSize: 15, color: CupertinoColors.systemGrey),
                      ),
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
