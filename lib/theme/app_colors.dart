import 'package:flutter/material.dart';

/// Centralized color + gradient tokens for the app.
///
/// Replaces the colors that used to be hard-coded across every page
/// (systemPink buttons, systemGrey6 fields, activeGreen/activeOrange roles).
class AppColors {
  AppColors._();

  /// Seed used to generate the Material 3 [ColorScheme] for both themes.
  static const Color seed = Color(0xFF6C5CE7);

  // Status colors.
  static const Color present = Color(0xFF22C55E);
  static const Color absent = Color(0xFFEF4444);

  // Role accent colors.
  static const Color teacher = Color(0xFF10B981);
  static const Color student = Color(0xFFF59E0B);

  // Brand gradient used for hero logos, primary buttons and avatars.
  static const List<Color> brandGradient = [
    Color(0xFF6C5CE7),
    Color(0xFF8E7CFF),
    Color(0xFF00B4D8),
  ];

  /// A small palette of book-cover gradients. A class is mapped to one of
  /// these deterministically from its name so each "book" looks distinct.
  static const List<List<Color>> bookGradients = [
    [Color(0xFF6C5CE7), Color(0xFF341F97)],
    [Color(0xFFEE5253), Color(0xFF8E1C1C)],
    [Color(0xFF0ABDE3), Color(0xFF1B5E91)],
    [Color(0xFF10AC84), Color(0xFF0B5D45)],
    [Color(0xFFF79F1F), Color(0xFFA15B0B)],
    [Color(0xFFEE5A8E), Color(0xFF8E2057)],
    [Color(0xFF576574), Color(0xFF2C3A47)],
    [Color(0xFF5F27CD), Color(0xFF341977)],
  ];

  /// Pick a stable gradient for [seedString] (e.g. a class name).
  static List<Color> bookGradientFor(String seedString) {
    if (seedString.isEmpty) return bookGradients.first;
    var hash = 0;
    for (final codeUnit in seedString.codeUnits) {
      hash = (hash * 31 + codeUnit) & 0x7fffffff;
    }
    return bookGradients[hash % bookGradients.length];
  }
}
