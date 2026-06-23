import 'package:flutter/material.dart';
import 'package:music_player/core/imports/packages_imports.dart';

class AppUnifiedCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double borderRadius;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final Border? border;

  const AppUnifiedCard({
    required this.child,
    this.onTap,
    this.borderRadius = 12.0,
    this.padding,
    this.backgroundColor,
    this.border,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Padding(
      padding: padding ?? EdgeInsets.all(12.w),
      child: child,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(borderRadius.r),
        border: border,
      ),
      child: onTap != null
          ? Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(borderRadius.r),
                child: cardContent,
              ),
            )
          : cardContent,
    );
  }
}
