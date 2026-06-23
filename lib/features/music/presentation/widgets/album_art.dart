import 'package:flutter/material.dart';
import 'package:music_player/core/imports/core_imports.dart';
import 'package:music_player/core/imports/packages_imports.dart';

class AlbumArt extends StatelessWidget {
  final String songId;
  final String imageUrl;

  const AlbumArt({
    required this.songId,
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Hero(
        tag: 'album_art_$songId',
        child: Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 20.r,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: CommonImage(
              imageUrl: imageUrl,
              width: 280.w,
              height: 280.h,
              borderRadius: 12.0,
            ),
          ),
        ),
      );
}
