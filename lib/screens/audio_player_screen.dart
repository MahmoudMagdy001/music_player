// ignore_for_file: library_private_types_in_public_api

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/screens/data/position_data.dart';
import 'package:rxdart/rxdart.dart';

import 'widgets/media_data.dart';
import 'widgets/controls.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({Key? key}) : super(key: key);

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  var scaffoldkey = GlobalKey<ScaffoldState>();
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.arrow_drop_up_rounded;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
  }

  final playlist = ConcatenatingAudioSource(
    children: [
      AudioSource.uri(
        Uri.parse('asset:///assets/audio/music.mp3'),
        tag: MediaItem(
          id: '0',
          title: 'Eminim Mix',
          artist: 'Eminim',
          artUri: Uri.parse(
              'https://hips.hearstapps.com/hmg-prod/images/eminem_photo_by_dave_j_hogan_getty_images_entertainment_getty_187596325.jpg?resize=1200:*'),
        ),
      ),
      AudioSource.uri(
        Uri.parse(
            'https://traffic.megaphone.fm/LI9282413157.mp3?updated=1666999832'),
        tag: MediaItem(
          id: '1',
          title:
              '4 predictions for the future of the creator economy [Creator Support]',
          artist: 'the Colin and Samir Show',
          artUri: Uri.parse(
              'https://people.com/thmb/1fYpw-YWFPUOwkRO78VwxJ86evg=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc():focal(665x0:667x2):format(webp)/gettyimages-567297577-2000-bd49c3564bf3430388205cf7994dcf18.jpg'),
        ),
      ),
    ],
  );

  late AudioPlayer _audioPlayer;

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _init();
  }

  Future<void> _init() async {
    await _audioPlayer.setLoopMode(LoopMode.all);
    await _audioPlayer.setAudioSource(playlist);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      floatingActionButton: musicList(context),
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0.0,
      //   leading: IconButton(
      //     onPressed: () {},
      //     icon: const Icon(Icons.keyboard_arrow_down_rounded),
      //   ),
      //   actions: [
      //     IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz))
      //   ],
      // ),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF144771),
              Color(0xFF071A2C),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<SequenceState?>(
              stream: _audioPlayer.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state?.sequence.isEmpty ?? true) {
                  return const SizedBox();
                }
                final metadata = state!.currentSource!.tag as MediaItem;
                return MediaMetaData(
                  imageUrl: metadata.artUri.toString(),
                  title: metadata.title,
                  artist: metadata.artist ?? '',
                );
              },
            ),
            const SizedBox(height: 20),
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return ProgressBar(
                  barHeight: 8,
                  baseBarColor: Colors.grey[600],
                  bufferedBarColor: Colors.grey,
                  progressBarColor: Colors.red,
                  thumbColor: Colors.red,
                  timeLabelTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  progress: positionData?.position ?? Duration.zero,
                  buffered: positionData?.bufferedPosition ?? Duration.zero,
                  total: positionData?.duration ?? Duration.zero,
                  onSeek: _audioPlayer.seek,
                );
              },
            ),
            const SizedBox(height: 20),
            Controls(audioPlayer: _audioPlayer),
          ],
        ),
      ),
    );
  }

  FloatingActionButton musicList(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: const Color(0xFF144771),
      child: Icon(fabIcon),
      onPressed: () {
        if (!isBottomSheetShown) {
          scaffoldkey.currentState?.showBottomSheet(
            backgroundColor: const Color(0xFF144771),
            elevation: 20.0,
            (context) {
              return Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StreamBuilder<SequenceState?>(
                      stream: _audioPlayer.sequenceStateStream,
                      builder: (context, snapshot) {
                        final state = snapshot.data;
                        if (state?.sequence.isEmpty ?? true) {
                          return const SizedBox();
                        }
                        return BottomSheet(
                          onClosing: () {},
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: 300,
                              child: ListView.builder(
                                itemCount: state!.sequence.length,
                                itemBuilder: (context, index) {
                                  final metadata =
                                      state.sequence[index].tag as MediaItem;
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          metadata.artUri.toString()),
                                    ),
                                    title: Text(metadata.title),
                                    subtitle: Text(metadata.artist ?? ''),
                                    onTap: () async {
                                      await _audioPlayer.seek(Duration.zero,
                                          index: index);
                                      _audioPlayer.play();
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
          isBottomSheetShown = true;
          fabIcon = Icons.arrow_drop_down_rounded;
        } else {
          Navigator.of(context).maybePop();
          isBottomSheetShown = false;
          fabIcon = Icons.arrow_drop_up_rounded;
        }
        setState(() {});
      },
    );
  }
}
