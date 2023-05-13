import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class ControlsWith extends StatelessWidget {
  const ControlsWith({
    super.key,
    required this.audioPlayer,
  });

  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (!(playing ?? false)) {
              return IconButton(
                iconSize: 30,
                color: Colors.white,
                onPressed: audioPlayer.play,
                icon: const Icon(Icons.play_arrow_rounded),
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                iconSize: 30,
                color: Colors.white,
                onPressed: audioPlayer.pause,
                icon: const Icon(
                  Icons.pause_rounded,
                ),
              );
            }
            return const Icon(
              Icons.play_arrow_rounded,
              size: 30,
              color: Colors.white,
            );
          },
        ),
      ],
    );
  }
}
