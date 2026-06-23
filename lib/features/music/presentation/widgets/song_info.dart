import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/core/imports/core_imports.dart';
import 'package:music_player/core/imports/packages_imports.dart';

class SongInfo extends StatefulWidget {
  final String title;
  final String? artist;

  const SongInfo({
    required this.title,
    required this.artist,
    super.key,
  });

  @override
  State<SongInfo> createState() => _SongInfoState();
}

class _SongInfoState extends State<SongInfo> {
  bool _liked = false;

  void _toggleLike() {
    unawaited(HapticFeedback.lightImpact());
    setState(() => _liked = !_liked);
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          // Title + Artist column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                4.vS,
                Text(
                  widget.artist ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Animated heart button
          GestureDetector(
            onTap: _toggleLike,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.elasticOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
              child: Icon(
                _liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                key: ValueKey(_liked),
                color: _liked ? context.appColors.success : Colors.white60,
                size: 26.r,
              ),
            ),
          ),
        ],
      );
}
