// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/screens/auth_screen/widgets/custom_text_form_field.dart';
import 'package:music_player/screens/player_screen/data/position_data.dart';
import 'package:music_player/screens/player_screen/widgets/custo_drawer.dart';
import 'package:music_player/screens/player_screen/widgets/player_screen.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({Key? key}) : super(key: key);

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  var scaffoldkey = GlobalKey<ScaffoldState>();
  bool isBottomSheetShown = false;
  IconData floatingIcon = Icons.arrow_drop_up_rounded;
  final user = FirebaseAuth.instance.currentUser;
  final auth = FirebaseAuth.instance;
  String _searchQuery = '';
  TextEditingController search = TextEditingController();

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
        Uri.parse('asset:///assets/audio/Saaban-Aleky.mp3'),
        tag: MediaItem(
          id: '1',
          title: 'MUSliM - Saaban Aleky',
          artist: 'MUSliM',
          artUri: Uri.parse(
              'https://mediaaws.almasryalyoum.com/news/large/2023/03/10/2052244_0.jpeg'),
        ),
      ),
      AudioSource.uri(
        Uri.parse('asset:///assets/audio/Mesh-Nadman.mp3'),
        tag: MediaItem(
          id: '2',
          title: 'MUSliM - Mesh Nadman',
          artist: 'MUSliM',
          artUri: Uri.parse('https://i.ytimg.com/vi/RBOhI_2I2Qo/default.jpg'),
        ),
      ),
      AudioSource.uri(
        Uri.parse('asset:///assets/audio/Meen-Kan-Sabab.mp3'),
        tag: MediaItem(
          id: '3',
          title: 'MUSliM - Meen Kan Sabab ',
          artist: 'MUSliM',
          artUri: Uri.parse(
              'https://i.scdn.co/image/ab67616d0000b273fb7a625e739662cb3aac982e'),
        ),
      ),
      AudioSource.uri(
        Uri.parse('asset:///assets/audio/Aleb-Fel-Dafater.mp3'),
        tag: MediaItem(
          id: '4',
          title: 'MUSliM - Aleb Fel Dafater',
          artist: 'MUSliM',
          artUri: Uri.parse('https://img.youtube.com/vi/uv2_g7wCvdw/0.jpg'),
        ),
      ),
      AudioSource.uri(
        Uri.parse('asset:///assets/audio/Etnaset.mp3'),
        tag: MediaItem(
          id: '5',
          title: 'MUSliM - Etnaset',
          artist: 'MUSliM',
          artUri: Uri.parse(
              'https://www.matb3aa.com/wp-content/uploads/2021/10/Etnasina-200x270.jpg'),
        ),
      ),
      AudioSource.uri(
        Uri.parse('asset:///assets/audio/Abl-Mawsalek.mp3'),
        tag: MediaItem(
          id: '6',
          title: 'MUSliM - Abl Mawsalek',
          artist: 'MUSliM',
          artUri: Uri.parse(
              'https://artwork.anghcdn.co/webp/?id=144816215&size=296'),
        ),
      ),
      AudioSource.uri(
        Uri.parse('asset:///assets/audio/Ghasb-Anny.mp3'),
        tag: MediaItem(
          id: '7',
          title: 'MUSliM & Zap Tharwat Ft. Sary Hany - Ghasb Anny ',
          artist: 'MUSliM & Zap Tharwat',
          artUri: Uri.parse('https://i.ytimg.com/vi/M4g-21W_ey8/default.jpg'),
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0.0,
        title: const Text(
          'Music List',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      drawer: MyDrawer(user: user, auth: auth),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF144771),
              Color.fromARGB(255, 10, 35, 59),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: customTextFormField(
                  type: TextInputType.text,
                  validator: (value) {
                    return null;
                  },
                  controller: search,
                  onChange: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                  label: 'Search',
                  prefix: Icons.search_rounded,
                ),
              ),
              Expanded(
                child: StreamBuilder<SequenceState?>(
                  stream: _audioPlayer.sequenceStateStream,
                  builder: (context, snapshot) {
                    final state = snapshot.data;
                    if (state?.sequence.isEmpty ?? true) {
                      return const SizedBox();
                    }
                    final filteredSequence = state!.sequence.where((item) =>
                        item.tag is MediaItem &&
                        (item.tag as MediaItem)
                            .title
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()));
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: filteredSequence.length,
                      itemBuilder: (context, index) {
                        final metadata =
                            filteredSequence.elementAt(index).tag as MediaItem;
                        return ListTile(
                          key: ValueKey(metadata.id),
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(metadata.artUri.toString()),
                          ),
                          title: Text(
                            metadata.title,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            metadata.artist ?? '',
                            style: const TextStyle(color: Colors.white),
                          ),
                          onTap: () async {
                            await _audioPlayer.seek(Duration.zero,
                                index: index);
                            _audioPlayer.play();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PlayerScreen(
                                    audioPlayer: _audioPlayer,
                                    positionDataStream: _positionDataStream),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
