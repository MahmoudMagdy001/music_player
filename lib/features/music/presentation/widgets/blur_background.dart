import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:music_player/core/imports/core_imports.dart';

class BlurBackground extends StatelessWidget {
  final String imageUrl;

  const BlurBackground({
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Positioned.fill(
            child: CommonImage(
              imageUrl: imageUrl,
              borderRadius: 0,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 45, sigmaY: 45),
              child: Container(
                color: Colors.black.withValues(alpha: 0.55),
              ),
            ),
          ),
        ],
      );
}
