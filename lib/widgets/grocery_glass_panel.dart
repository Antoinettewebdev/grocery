import 'dart:ui';

import 'package:flutter/material.dart';

/// Frosted glass list card — styling only; does not affect [GroceryBackdrop].
class GroceryGlassPanel extends StatelessWidget {
  const GroceryGlassPanel({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.onTap,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;

  static const double _blurSigma = 10;
  static const double _fillOpacity = 0.72;
  static const double _borderOpacity = 0.55;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.35),
            blurRadius: 1,
            offset: const Offset(0, -0.5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: _blurSigma,
            sigmaY: _blurSigma,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: Colors.white.withValues(alpha: _fillOpacity),
              border: Border.all(
                color: Colors.white.withValues(alpha: _borderOpacity),
                width: 1.25,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: onTap == null
                  ? child
                  : InkWell(
                      onTap: onTap,
                      borderRadius: borderRadius,
                      splashColor: Colors.black.withValues(alpha: 0.06),
                      highlightColor: Colors.black.withValues(alpha: 0.04),
                      child: child,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
