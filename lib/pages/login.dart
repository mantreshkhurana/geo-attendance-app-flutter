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

  // Demo role selected via the pill switch (mock mode only).
  String _role = 'Student';

  @override
  void initState() {
    super.initState();
    if (backend.isMock) _applyDemoCredentials(_role);
  }

  /// Pre-fills the form with the demo account for [role] so the chosen persona
  /// lands on rich, role-appropriate mock data.
  void _applyDemoCredentials(String role) {
    emailController.text =
        role == 'Teacher' ? 'teacher@demo.com' : 'student@demo.com';
    passwordController.text = 'demo1234';
  }

  void _selectRole(String role) {
    setState(() => _role = role);
    _applyDemoCredentials(role);
  }

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
                  if (backend.isMock) ...[
                    const SizedBox(height: 24),
                    AnimatedEntrance(
                      index: 3,
                      child: _RolePill(value: _role, onChanged: _selectRole),
                    ),
                  ],
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
                        final shouldNavigate = await login(
                          context,
                          emailController.text,
                          passwordController.text,
                          role: backend.isMock ? _role : null,
                        );
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

/// Pill-shaped Teacher / Student selector with a sliding amber thumb.
/// Shown only in mock/demo mode to pick which role's seeded data to explore.
class _RolePill extends StatelessWidget {
  final String value; // 'Student' | 'Teacher'
  final ValueChanged<String> onChanged;

  const _RolePill({required this.value, required this.onChanged});

  static const _options = <String, IconData>{
    'Student': FontAwesomeIcons.userGraduate,
    'Teacher': FontAwesomeIcons.chalkboardUser,
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isStudent = value == 'Student';
    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final thumbWidth = constraints.maxWidth / 2;
          return Stack(
            children: [
              AnimatedAlign(
                alignment:
                    isStudent ? Alignment.centerLeft : Alignment.centerRight,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                child: Container(
                  width: thumbWidth,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.brandGradient,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.seed.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: _options.entries.map((entry) {
                  final selected = entry.key == value;
                  final color =
                      selected ? AppColors.onBrand : scheme.onSurfaceVariant;
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onChanged(entry.key),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(entry.value, size: 14, color: color),
                          const SizedBox(width: 8),
                          Text(
                            entry.key,
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
