import 'dart:async';

import 'package:music_player/core/imports/packages_imports.dart';
import 'package:music_player/core/shared/bloc/safe_bloc.dart';
import 'package:music_player/features/music/domain/usecases/get_songs.dart';
import 'package:music_player/features/music/presentation/bloc/music_event.dart';
import 'package:music_player/features/music/presentation/bloc/music_state.dart';

class MusicBloc extends SafeBloc<MusicEvent, MusicState> {
  final GetTracks getTracks;

  MusicBloc(this.getTracks) : super(MusicState.initial()) {
    this
      ..on<LoadSongs>(_onLoadSongs)
      ..on<SearchSongs>(
        _onSearchSongs,
        transformer: (events, mapper) => events
            .debounceTime(const Duration(milliseconds: 500))
            .switchMap(mapper),
      );
  }

  Future<void> _onLoadSongs(LoadSongs event, Emitter<MusicState> emit) async {
    emit(state.copyWith(status: MusicStatus.loading));
    // Load top Egyptian songs by default (defaults to Amr Diab in remote datasource)
    final result = await getTracks();
    final newState = result.fold(
      (failure) => state.copyWith(
        status: MusicStatus.error,
        errorMessage: failure.message,
      ),
      (songs) => state.copyWith(
        status: MusicStatus.success,
        songs: songs,
      ),
    );
    emit(newState);
  }

  Future<void> _onSearchSongs(SearchSongs event, Emitter<MusicState> emit) async {
    final query = event.query.trim();
    emit(state.copyWith(status: MusicStatus.loading));

    // If query is empty, revert to default top Egyptian music
    final result = query.isEmpty
        ? await getTracks()
        : await getTracks(search: query);

    final newState = result.fold(
      (failure) => state.copyWith(
        status: MusicStatus.error,
        errorMessage: failure.message,
      ),
      (songs) => state.copyWith(
        status: MusicStatus.success,
        songs: songs,
      ),
    );
    emit(newState);
  }
}
