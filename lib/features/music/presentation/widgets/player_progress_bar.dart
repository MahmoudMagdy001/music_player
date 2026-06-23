import 'package:flutter/material.dart';
import 'package:music_player/core/imports/core_imports.dart';
import 'package:music_player/core/imports/packages_imports.dart';

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

class PlayerProgressBar extends StatelessWidget {
  const PlayerProgressBar({super.key});

  Stream<PositionData> _positionDataStream(AudioPlayer player) =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        player.positionStream,
        player.bufferedPositionStream,
        player.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final player = getIt<AudioPlayer>();

    return StreamBuilder<PositionData>(
      stream: _positionDataStream(player),
      builder: (context, sliderSnap) {
        final posData = sliderSnap.data;
        final position = posData?.position ?? Duration.zero;
        final buffered = posData?.bufferedPosition ?? Duration.zero;
        final duration = posData?.duration ?? Duration.zero;

        return ProgressBar(
          progress: position,
          buffered: buffered,
          total: duration,
          barHeight: 5.h,
          baseBarColor: Colors.white24,
          bufferedBarColor: Colors.white38,
          progressBarColor: context.appColors.success,
          thumbColor: Colors.white,
          thumbRadius: 7.r,
          thumbGlowRadius: 16.r,
          thumbGlowColor: context.appColors.success.withValues(alpha: 0.30),
          timeLabelTextStyle: TextStyle(
            color: Colors.white60,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
          onSeek: player.seek,
        );
      },
    );
  }
}
