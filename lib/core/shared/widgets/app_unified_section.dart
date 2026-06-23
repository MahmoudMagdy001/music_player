import 'package:flutter/material.dart';
import 'package:music_player/core/imports/packages_imports.dart';

class AppUnifiedSection extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;
  final EdgeInsets? padding;

  const AppUnifiedSection({
    required this.title,
    required this.child,
    this.trailing,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
      padding: padding ?? EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
}
