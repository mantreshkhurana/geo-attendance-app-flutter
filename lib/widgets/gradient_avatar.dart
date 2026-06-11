import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_colors.dart';

/// Circular avatar built entirely from widgets — replaces the
/// `profile_image.png` asset. Shows the user's initials over a gradient
/// derived from their name, with a FontAwesome person fallback.
class GradientAvatar extends StatelessWidget {
  final String name;
  final double radius;

  const GradientAvatar({
    super.key,
    required this.name,
    this.radius = 28,
  });

  String get _initials {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final gradient = AppColors.bookGradientFor(name);
    final initials = _initials;
    return Container(
      height: radius * 2,
      width: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: gradient.last.withValues(alpha: 0.4),
            blurRadius: radius * 0.5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: initials.isEmpty
            ? Icon(FontAwesomeIcons.user, color: Colors.white, size: radius)
            : Text(
                initials,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: radius * 0.8,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}
