import 'package:flutter/material.dart';

/// Premium text styles for legibility on the grocery photo.
/// Does not affect backdrop, image, or overlays.
abstract final class GroceryTypography {
  static const Color primaryText = Color(0xFF0A140E);
  static const Color secondaryText = Color(0xFF3D5245);
  static const Color mutedText = Color(0xFF6B7F72);
  static const Color iconColor = Color(0xFF1E3326);

  static const List<Shadow> titleShadow = [
    Shadow(
      color: Color(0xE8FFFFFF),
      blurRadius: 16,
      offset: Offset(0, 0),
    ),
    Shadow(
      color: Color(0x99000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<Shadow> bodyShadow = [
    Shadow(
      color: Color(0xCCFFFFFF),
      blurRadius: 10,
      offset: Offset(0, 0),
    ),
    Shadow(
      color: Color(0x66000000),
      blurRadius: 5,
      offset: Offset(0, 1),
    ),
  ];

  static TextStyle appBarTitle(TextTheme theme) {
    return (theme.headlineSmall ?? const TextStyle(fontSize: 28)).copyWith(
      color: primaryText,
      fontWeight: FontWeight.w800,
      fontSize: 28,
      letterSpacing: -0.6,
      height: 1.15,
      shadows: titleShadow,
    );
  }

  static TextStyle emptyState(TextTheme theme) {
    return (theme.bodyLarge ?? const TextStyle(fontSize: 17)).copyWith(
      color: primaryText,
      fontWeight: FontWeight.w600,
      fontSize: 17,
      height: 1.55,
      letterSpacing: 0.1,
      shadows: bodyShadow,
    );
  }

  static TextStyle fabLabel(Color onPrimary) {
    return TextStyle(
      color: onPrimary,
      fontWeight: FontWeight.w800,
      fontSize: 16,
      letterSpacing: 0.35,
      height: 1.2,
    );
  }

  static TextStyle listCardTitle(TextTheme theme) {
    return (theme.titleMedium ?? const TextStyle(fontSize: 18)).copyWith(
      color: primaryText,
      fontWeight: FontWeight.bold,
      fontSize: 18,
      letterSpacing: -0.2,
      height: 1.25,
      shadows: bodyShadow,
    );
  }

  static TextStyle listCardSubtitle(TextTheme theme) {
    return (theme.bodyMedium ?? const TextStyle(fontSize: 14)).copyWith(
      color: secondaryText,
      fontWeight: FontWeight.w500,
      fontSize: 14,
      height: 1.35,
      letterSpacing: 0.05,
    );
  }

  static TextStyle itemTitle({required bool bought}) {
    return TextStyle(
      color: bought ? mutedText : primaryText,
      fontWeight: FontWeight.bold,
      fontSize: 17,
      height: 1.3,
      letterSpacing: -0.15,
      decoration: bought ? TextDecoration.lineThrough : null,
      decorationColor: mutedText,
      decorationThickness: 2,
      shadows: bought ? null : bodyShadow,
    );
  }
}
