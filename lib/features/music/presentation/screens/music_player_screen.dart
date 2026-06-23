import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_player/core/imports/core_imports.dart';
import 'package:music_player/core/imports/packages_imports.dart';
import 'package:music_player/features/music/presentation/widgets/widgets.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  double _dragOffset = 0.0;

  void _showQueueSheet(BuildContext context, AudioPlayer player) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => const QueueSheetContent(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final player = getIt<AudioPlayer>();

    return StreamBuilder<SequenceState?>(
      stream: player.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state == null || state.currentSource == null) {
          return const Scaffold(
            backgroundColor: Color(0xFF121212),
            body: Center(child: AppLoading()),
          );
        }

        final metadata = state.currentSource!.tag as MediaItem;

        return Scaffold(
          backgroundColor: Colors.black,
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onVerticalDragUpdate: (details) {
              setState(() {
                _dragOffset = (_dragOffset + details.delta.dy)
                    .clamp(0.0, double.infinity);
              });
            },
            onVerticalDragEnd: (details) {
              if (_dragOffset > 100 ||
                  (details.primaryVelocity != null &&
                      details.primaryVelocity! > 300)) {
                Navigator.pop(context);
              } else {
                setState(() {
                  _dragOffset = 0.0;
                });
              }
            },
            onVerticalDragCancel: () {
              setState(() {
                _dragOffset = 0.0;
              });
            },
            child: Transform.translate(
              offset: Offset(0, _dragOffset),
              child: Stack(
                children: [
                  // 1. Blurred Background Image
                  BlurBackground(imageUrl: metadata.artUri.toString()),

                  // 2. Playback Interface
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        children: [
                          // Top Action Bar
                          PlayerHeader(
                            album: metadata.album,
                            onBackTap: () => Navigator.pop(context),
                          ),
                          const Spacer(),

                          // Album Art
                          AlbumArt(
                            songId: metadata.id,
                            imageUrl: metadata.artUri.toString(),
                          ),
                          const Spacer(),

                          // Song Titles
                          SongInfo(
                            title: metadata.title,
                            artist: metadata.artist,
                          ),
                          20.vS,

                          // Progress Slider Bar
                          const PlayerProgressBar(),
                          12.vS,

                          // Playback Buttons Panel
                          const PlayerControlButtons(),
                          const Spacer(),

                          // Bottom Options / Lyrics / Queue Icons
                          PlayerBottomOptions(
                            onQueueTap: () => _showQueueSheet(context, player),
                          ),
                          12.vS,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
