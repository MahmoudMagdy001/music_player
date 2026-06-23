import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_player/core/imports/core_imports.dart';
import 'package:music_player/core/imports/packages_imports.dart';
import 'package:music_player/features/music/domain/entities/song.dart';
import 'package:music_player/features/music/presentation/bloc/music_bloc.dart';
import 'package:music_player/features/music/presentation/bloc/music_event.dart';
import 'package:music_player/features/music/presentation/bloc/music_state.dart';
import 'package:music_player/features/music/presentation/screens/music_player_screen.dart';
import 'package:music_player/features/music/presentation/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Dispatch load event
    context.read<MusicBloc>().add(LoadSongs());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initPlayerPlaylist(List<Song> songs) async {
    final player = getIt<AudioPlayer>();
    if (player.sequence.isEmpty) {
      final sources = songs.map((song) {
        final uriStr = song.audioPath.startsWith('assets/')
            ? 'asset:///${song.audioPath}'
            : song.audioPath;
        return AudioSource.uri(
          Uri.parse(uriStr),
          tag: MediaItem(
            id: song.id,
            title: song.title,
            artist: song.artist,
            artUri: Uri.parse(song.imageUrl),
          ),
        );
      }).toList();
      await player.setAudioSources(sources);
      await player.setLoopMode(LoopMode.all);
    }
  }

  void _navigateToPlayer(BuildContext context, int index) async {
    final player = getIt<AudioPlayer>();
    await player.seek(Duration.zero, index: index);
    unawaited(player.play());

    if (!context.mounted) return;
    unawaited(MusicPlayerScreen.show(context));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFF121212), // Deep dark Spotify color
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0F2615), // Very deep green shade
                Color(0xFF121212),
                Color(0xFF121212),
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Connection Status Bar
                const NetworkStatusBar(),

                // Title Header
                const HomeHeader(),

                // Search Bar
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: AppTextField(
                    controller: _searchController,
                    labelText: context.l10n.searchPlaceholder,
                    prefixIcon: Icons.search_rounded,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                  ),
                ),

                // Content Body
                Expanded(
                  child: BlocConsumer<MusicBloc, MusicState>(
                    listener: (context, state) {
                      if (state.status == MusicStatus.success) {
                        unawaited(_initPlayerPlaylist(state.songs));
                      }
                    },
                    builder: (context, state) {
                      if (state.status == MusicStatus.loading) {
                        return const AppLoading();
                      } else if (state.status == MusicStatus.error) {
                        return Center(
                          child: Text(
                            state.errorMessage ?? 'Error occurred',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      // Filter list
                      final filteredSongs = state.songs
                          .where(
                            (song) =>
                                song.title
                                    .toLowerCase()
                                    .contains(_searchQuery.toLowerCase()) ||
                                song.artist
                                    .toLowerCase()
                                    .contains(_searchQuery.toLowerCase()),
                          )
                          .toList();

                      return ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          12.vS,
                          // Quick Grid Recommended
                          QuickRecommendationsGrid(
                            filteredSongs: filteredSongs,
                            allSongs: state.songs,
                            onSongTap: (index) =>
                                _navigateToPlayer(context, index),
                          ),

                          // Album highlights (horizontal list)
                          HotHitsList(
                            filteredSongs: filteredSongs,
                            allSongs: state.songs,
                            onSongTap: (index) =>
                                _navigateToPlayer(context, index),
                          ),

                          // Track List
                          AllTracksList(
                            filteredSongs: filteredSongs,
                            allSongs: state.songs,
                            onSongTap: (index) =>
                                _navigateToPlayer(context, index),
                          ),
                          60.vS, // Buffer space for mini-player
                        ],
                      );
                    },
                  ),
                ),

                // Sticky Mini Player
                const MiniPlayer(),
              ],
            ),
          ),
        ),
      );
}
