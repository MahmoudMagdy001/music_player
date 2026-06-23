import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:music_player/core/imports/core_imports.dart';
import 'package:music_player/core/imports/packages_imports.dart';
import 'package:music_player/features/music/presentation/screens/music_player_screen.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final player = getIt<AudioPlayer>();

    return StreamBuilder<SequenceState?>(
      stream: player.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state == null || state.currentSource == null) {
          return const SizedBox.shrink();
        }

        final metadata = state.currentSource!.tag as MediaItem;

        return Container(
          height: 68.h,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Stack(
              children: [
                // ── Blurred album art backdrop ──────────────────────
                Positioned.fill(
                  child: CommonImage(
                    imageUrl: metadata.artUri.toString(),
                    borderRadius: 0,
                  ),
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.72),
                            Colors.black.withValues(alpha: 0.60),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Content ─────────────────────────────────────────
                InkWell(
                  borderRadius: BorderRadius.circular(12.r),
                  onTap: () => MusicPlayerScreen.show(context),
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Row(
                            children: [
                              // Album thumbnail
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6.r),
                                child: CommonImage(
                                  imageUrl: metadata.artUri.toString(),
                                  width: 44.w,
                                  height: 44.h,
                                  borderRadius: 6.0,
                                ),
                              ),
                              10.hS,

                              // Song info
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      metadata.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    2.vS,
                                    Text(
                                      metadata.artist ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white60,
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Prev Button
                              IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.skip_previous_rounded,
                                  color: Colors.white,
                                  size: 28.r,
                                ),
                                onPressed: player.seekToPrevious,
                              ),

                              // Play/Pause Button
                              StreamBuilder<PlayerState>(
                                stream: player.playerStateStream,
                                builder: (context, snap) {
                                  final playing = snap.data?.playing ?? false;
                                  return IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(
                                      playing
                                          ? Icons.pause_rounded
                                          : Icons.play_arrow_rounded,
                                      color: Colors.white,
                                      size: 32.r,
                                    ),
                                    onPressed: () => playing
                                        ? player.pause()
                                        : player.play(),
                                  );
                                },
                              ),

                              // Next Button
                              IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.skip_next_rounded,
                                  color: Colors.white,
                                  size: 28.r,
                                ),
                                onPressed: player.seekToNext,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ── Green progress line at bottom ────────────
                      StreamBuilder<Duration>(
                        stream: player.positionStream,
                        builder: (context, posSnap) {
                          final position = posSnap.data ?? Duration.zero;
                          final duration = player.duration ?? Duration.zero;
                          final progress = duration.inMilliseconds > 0
                              ? position.inMilliseconds /
                                  duration.inMilliseconds
                              : 0.0;
                          return Align(
                            alignment: Alignment.bottomLeft,
                            child: FractionallySizedBox(
                              widthFactor: progress.clamp(0.0, 1.0),
                              child: Container(
                                height: 3.h,
                                decoration: BoxDecoration(
                                  color: context.appColors.success,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(2.r),
                                    bottomRight: Radius.circular(2.r),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
