import 'package:flutter/material.dart';
import 'package:music_player/core/extensions/sizing_extensions.dart';
import 'package:music_player/core/imports/packages_imports.dart';

class PlayerBottomOptions extends StatelessWidget {
  final VoidCallback onQueueTap;

  const PlayerBottomOptions({
    required this.onQueueTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Subtle divider
          Divider(
            color: Colors.white.withValues(alpha: 0.08),
            height: 1,
            thickness: 1,
          ),
          12.vS,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Devices / Cast icon
              IconButton(
                icon: Icon(
                  Icons.devices_rounded,
                  color: Colors.white54,
                  size: 22.r,
                ),
                onPressed: () {},
              ),

              // Share icon (center)
              IconButton(
                icon: Icon(
                  Icons.ios_share_rounded,
                  color: Colors.white54,
                  size: 20.r,
                ),
                onPressed: () {},
              ),

              // Queue icon
              IconButton(
                icon: Icon(
                  Icons.playlist_play_rounded,
                  color: Colors.white54,
                  size: 28.r,
                ),
                onPressed: onQueueTap,
              ),
            ],
          ),
        ],
      );
}
