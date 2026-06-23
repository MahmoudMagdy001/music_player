import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_player/core/imports/core_imports.dart';
import 'package:music_player/core/imports/packages_imports.dart';
import 'package:music_player/features/music/presentation/widgets/widgets.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  static Future<void> show(BuildContext context) => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withValues(alpha: 0.5),
        builder: (context) => const MusicPlayerScreen(),
      );

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // Trigger fade-in on next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _opacity = 1.0);
    });
  }

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
        final bottomInset = MediaQuery.of(context).padding.bottom;

        return AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOut,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  // 1. Blurred Background Image
                  BlurBackground(imageUrl: metadata.artUri.toString()),

                  // 2. Playback Interface
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 30.h,
                        left: 20.w,
                        right: 20.w,
                      ),
                      child: Column(
                        children: [
                          // Top Action Bar (includes drag handle)
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

                          // Song Title + Artist + Heart
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

                          // Bottom Options / Share / Queue Icons
                          PlayerBottomOptions(
                            onQueueTap: () => _showQueueSheet(context, player),
                          ),
                          SizedBox(height: 12.h + bottomInset),
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
