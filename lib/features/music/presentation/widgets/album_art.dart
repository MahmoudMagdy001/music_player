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
  Widget build(BuildContext context) {
    final player = getIt<AudioPlayer>();

    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (context, snap) {
        final playing = snap.data?.playing ?? false;

        return AnimatedScale(
          scale: playing ? 1.03 : 0.92,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutBack,
          child: Hero(
            tag: 'album_art_$songId',
            child: Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withValues(alpha: playing ? 0.55 : 0.30),
                      blurRadius: playing ? 40.r : 20.r,
                      offset: const Offset(0, 12),
                    ),
                    if (playing)
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.06),
                        blurRadius: 60.r,
                        spreadRadius: 2,
                      ),
                  ],
                ),
                child: CommonImage(
                  imageUrl: imageUrl,
                  width: 300.w,
                  height: 300.h,
                  borderRadius: 16.0.r,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
