import 'dart:async';
import 'package:flutter/material.dart';
import 'package:music_player/core/imports/core_imports.dart';
import 'package:music_player/core/imports/packages_imports.dart';

class PlayerControlButtons extends StatelessWidget {
  const PlayerControlButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final player = getIt<AudioPlayer>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Shuffle Button
        StreamBuilder<bool>(
          stream: player.shuffleModeEnabledStream,
          builder: (context, shuffleSnap) {
            final enabled = shuffleSnap.data ?? false;
            return IconButton(
              icon: Icon(
                Icons.shuffle_rounded,
                color: enabled ? context.appColors.success : Colors.white54,
                size: 24.r,
              ),
              onPressed: () => player.setShuffleModeEnabled(!enabled),
            );
          },
        ),

        // Previous Button
        IconButton(
          icon: Icon(
            Icons.skip_previous_rounded,
            color: Colors.white,
            size: 40.r,
          ),
          onPressed: player.seekToPrevious,
        ),

        // Play / Pause central button
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, playerStateSnap) {
            final playerState = playerStateSnap.data;
            final playing = playerState?.playing ?? false;
            final processingState = playerState?.processingState;

            if (processingState == ProcessingState.buffering) {
              return SizedBox(
                width: 68.w,
                height: 68.h,
                child: const AppLoading(),
              );
            }

            return InkWell(
              onTap: playing ? player.pause : player.play,
              borderRadius: BorderRadius.circular(34.r),
              child: Container(
                width: 68.w,
                height: 68.h,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: Colors.black,
                  size: 38.r,
                ),
              ),
            );
          },
        ),

        // Next Button
        IconButton(
          icon: Icon(
            Icons.skip_next_rounded,
            color: Colors.white,
            size: 40.r,
          ),
          onPressed: player.seekToNext,
        ),

        // Repeat Button
        StreamBuilder<LoopMode>(
          stream: player.loopModeStream,
          builder: (context, loopSnap) {
            final loopMode = loopSnap.data ?? LoopMode.off;
            var iconColor = Colors.white54;
            var iconData = Icons.repeat_rounded;

            if (loopMode == LoopMode.one) {
              iconColor = context.appColors.success;
              iconData = Icons.repeat_one_rounded;
            } else if (loopMode == LoopMode.all) {
              iconColor = context.appColors.success;
              iconData = Icons.repeat_rounded;
            }

            return IconButton(
              icon: Icon(
                iconData,
                color: iconColor,
                size: 24.r,
              ),
              onPressed: () {
                if (loopMode == LoopMode.off) {
                  unawaited(player.setLoopMode(LoopMode.all));
                } else if (loopMode == LoopMode.all) {
                  unawaited(player.setLoopMode(LoopMode.one));
                } else {
                  unawaited(player.setLoopMode(LoopMode.off));
                }
              },
            );
          },
        ),
      ],
    );
  }
}
