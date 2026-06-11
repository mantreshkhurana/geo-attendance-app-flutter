import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Animated, widget-built logo for the auth screens — replaces the
/// `login.png` / `register.png` images. A gradient rounded square with an
/// icon that gently floats and pulses.
class AuthHero extends StatefulWidget {
  final IconData icon;

  const AuthHero({super.key, required this.icon});

  @override
  State<AuthHero> createState() => _AuthHeroState();
}

class _AuthHeroState extends State<AuthHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_controller.value);
        return Transform.translate(
          offset: Offset(0, -6 + t * 12),
          child: child,
        );
      },
      child: Container(
        height: 110,
        width: 110,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: AppColors.brandGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: AppColors.seed.withValues(alpha: 0.4),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Icon(widget.icon, color: Colors.white, size: 50),
      ),
    );
  }
}
