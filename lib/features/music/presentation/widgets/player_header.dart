import 'package:flutter/material.dart';
import 'package:music_player/core/imports/core_imports.dart';
import 'package:music_player/core/imports/packages_imports.dart';

class PlayerHeader extends StatelessWidget {
  final String? album;
  final VoidCallback onBackTap;

  const PlayerHeader({
    required this.album,
    required this.onBackTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white,
              size: 30.r,
            ),
            onPressed: onBackTap,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.player.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                2.vS,
                Text(
                  album ?? 'Single',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Opacity(
            opacity: 0,
            child: IgnorePointer(
              child: IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 30.r,
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      );
}
