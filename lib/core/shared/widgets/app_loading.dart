import 'package:flutter/material.dart';
import 'package:music_player/core/imports/core_imports.dart';
import 'package:music_player/core/imports/packages_imports.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key});

  @override
  Widget build(BuildContext context) => Center(
      child: CircularProgressIndicator(
        color: context.appColors.success, // Beautiful Spotify Green indicator
        strokeWidth: 3.w,
      ),
    );
}
