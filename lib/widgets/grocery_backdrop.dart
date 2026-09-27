import 'package:flutter/material.dart';

/// Full-bleed grocery image with a light dark scrim for text — no white wash.
class GroceryBackdrop extends StatelessWidget {
  const GroceryBackdrop({super.key});

  static const assetPath = 'assets/images/grocery_bg.png';

  /// Subtle dark scrim (15–25%) for title / FAB legibility only.
  static const double scrimOpacity = 0.22;

  /// Frosted panel tint over the photo (dark, low opacity — image stays visible).
  static const double glassOpacity = 0.22;

  static const double glassBlurSigma = 6;

  static const List<Shadow> textShadows = [
    Shadow(
      color: Color(0xB3000000),
      blurRadius: 14,
      offset: Offset(0, 1),
    ),
    Shadow(
      color: Color(0x66000000),
      blurRadius: 4,
      offset: Offset(0, 0.5),
    ),
  ];

  static TextStyle readableText(
    TextTheme theme, {
    TextStyle? base,
    Color? color,
    FontWeight? fontWeight,
  }) {
    final resolved = base ?? theme.bodyLarge!;
    return resolved.copyWith(
      color: color ?? resolved.color,
      fontWeight: fontWeight ?? FontWeight.w600,
      shadows: textShadows,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          assetPath,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (context, error, _) =>
              ColoredBox(color: scheme.primary.withValues(alpha: 0.35)),
        ),
        // Top: gentle dark scrim so the app bar title stays readable.
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: scrimOpacity),
                Colors.black.withValues(alpha: scrimOpacity * 0.4),
                Colors.transparent,
              ],
              stops: const [0.0, 0.16, 0.38],
            ),
          ),
        ),
        // Bottom: same strength for the FAB area.
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withValues(alpha: scrimOpacity),
                Colors.transparent,
              ],
              stops: const [0.0, 0.32],
            ),
          ),
        ),
      ],
    );
  }
}
