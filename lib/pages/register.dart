import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import '../../screens/screens.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyRegisterPageState createState() => _MyRegisterPageState();
}

class _MyRegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: const [GestureType.onTap, GestureType.onPanUpdateDownDirection],
      child: SafeArea(
        child: CupertinoPageScaffold(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 170,
                    width: 170,
                    child: Image(
                      image: AssetImage(
                        'assets/images/register.png',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Register',
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
                      maxLength: 20,
                      controller: nameController,
                      placeholder: 'Name',
                      prefix: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(
                          CupertinoIcons.person_crop_circle,
                          size: 23,
                          color: CupertinoColors.systemGrey,
                        ),
                        onPressed: () {
                          goTo(context, const ProfilePage());
                        },
                      ),
                      keyboardType: TextInputType.text,
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
                      controller: emailController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9a-z@.]")),
                      ],
                      placeholder: 'Email',
                      prefix: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(
                          CupertinoIcons.mail,
                          size: 23,
                          color: CupertinoColors.systemGrey,
                        ),
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
                        child: const Icon(
                          CupertinoIcons.padlock,
                          size: 23,
                          color: CupertinoColors.systemGrey,
                        ),
                        onPressed: () {
                          goTo(context, const ProfilePage());
                        },
                      ),
                      obscureText: true,
                      maxLength: 12,
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
                      controller: confirmPasswordController,
                      placeholder: 'Confirm Password',
                      prefix: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(
                          CupertinoIcons.padlock,
                          size: 23,
                          color: CupertinoColors.systemGrey,
                        ),
                        onPressed: () {
                          goTo(context, const ProfilePage());
                        },
                      ),
                      obscureText: true,
                      maxLength: 12,
                      textInputAction: TextInputAction.done,
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 50,
                    child: CupertinoButton(
                      color: CupertinoColors.systemPink,
                      onPressed: () async {
                        if (confirmPasswordController.text ==
                            passwordController.text) {
                          bool shouldNavigate = await register(context,
                              emailController.text, passwordController.text);

                          if (shouldNavigate) {
                            await addUser(
                              nameController.text,
                              emailController.text,
                            );
                            // ignore: use_build_context_synchronously
                            goFront(context, const MyHomePage());
                          }
                        } else {
                          showCupertinoDialog(
                            context: context,
                            builder: passwordDidNotMatch,
                          );
                        }
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: const Text('Register'),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: GestureDetector(
                      onTap: () {
                        goFront(context, const LoginPage());
                      },
                      child: const Text(
                        'Already have an Account? Login',
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
