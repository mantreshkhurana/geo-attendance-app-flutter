import 'package:flutter/material.dart';

/// Centralized color + gradient tokens for the app.
///
/// Replaces the colors that used to be hard-coded across every page
/// (systemPink buttons, systemGrey6 fields, activeGreen/activeOrange roles).
class AppColors {
  AppColors._();

  // ---- Amber & Platinum brand palette ----
  /// Warm amber used as the primary brand color.
  static const Color amber = Color(0xFFFFB300); // amber 600
  static const Color amberDeep = Color(0xFFFF8F00); // amber 800
  /// Cool platinum / silver used as the secondary brand tone.
  static const Color platinum = Color(0xFFE5E4E2);
  static const Color platinumDeep = Color(0xFF9CA3AF);

  /// Seed used to generate the Material 3 [ColorScheme] for both themes.
  static const Color seed = amberDeep;

  /// Dark foreground used for text/icons drawn on the (light) amber–platinum
  /// brand gradient, where white would be unreadable.
  static const Color onBrand = Color(0xFF26201A);

  // Status colors (kept semantic for clarity).
  static const Color present = Color(0xFF22C55E);
  static const Color absent = Color(0xFFEF4444);

  // Role accent colors, aligned to the amber / platinum palette.
  static const Color teacher = amberDeep;
  static const Color student = Color(0xFF78909C); // platinum slate

  // Brand gradient (amber → platinum) used for hero logos, primary buttons
  // and avatars.
  static const List<Color> brandGradient = [
    amberDeep,
    amber,
    platinum,
  ];

  /// A small palette of book-cover gradients, all amber / platinum variations
  /// so each class looks distinct while staying on-brand. A class is mapped to
  /// one deterministically from its name.
  ///
  /// Tones are kept deep enough that the white card text stays legible.
  static const List<List<Color>> bookGradients = [
    [Color(0xFFE8930C), Color(0xFF7A4A06)], // amber → brown
    [Color(0xFFC8860D), Color(0xFF6B4A0B)], // gold → bronze
    [Color(0xFF9CA3AF), Color(0xFF4B5563)], // platinum → graphite
    [Color(0xFFB5651D), Color(0xFF5E3409)], // amber orange
    [Color(0xFFA8853A), Color(0xFF5A4410)], // antique gold
    [Color(0xFF8A8D91), Color(0xFF43474D)], // platinum slate
    [Color(0xFFC19A3E), Color(0xFF6E5111)], // champagne gold
    [Color(0xFF78909C), Color(0xFF37474F)], // cool platinum
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
