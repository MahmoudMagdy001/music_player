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
          // Full-screen blurred art
          Positioned.fill(
            child: CommonImage(
              imageUrl: imageUrl,
              borderRadius: 0,
            ),
          ),
          // Heavy blur layer
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: const SizedBox.expand(),
            ),
          ),
          // Rich gradient overlay: transparent top → deep black bottom
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.35),
                    Colors.black.withValues(alpha: 0.10),
                    Colors.black.withValues(alpha: 0.60),
                    Colors.black.withValues(alpha: 0.90),
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
          ),
        ],
      );
}
