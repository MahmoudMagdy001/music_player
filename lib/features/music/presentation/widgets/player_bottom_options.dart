import 'package:flutter/material.dart';
import 'package:music_player/core/imports/packages_imports.dart';

class PlayerBottomOptions extends StatelessWidget {
  final VoidCallback onQueueTap;

  const PlayerBottomOptions({
    required this.onQueueTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.devices_rounded,
              color: Colors.white54,
              size: 20.r,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.playlist_play_rounded,
              color: Colors.white54,
              size: 26.r,
            ),
            onPressed: onQueueTap,
          ),
        ],
      );
}
