import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/shared/bloc/safe_bloc.dart';
import 'package:music_player/features/music/domain/usecases/get_songs.dart';
import 'package:music_player/features/music/presentation/bloc/music_event.dart';
import 'package:music_player/features/music/presentation/bloc/music_state.dart';

class MusicBloc extends SafeBloc<MusicEvent, MusicState> {
  final GetSongs getSongs;

  MusicBloc(this.getSongs) : super(MusicState.initial()) {
    on<LoadSongs>(_onLoadSongs);
  }

  Future<void> _onLoadSongs(LoadSongs event, Emitter<MusicState> emit) async {
    emit(state.copyWith(status: MusicStatus.loading));
    final result = await getSongs();
    result.fold(
      (failure) => emit(state.copyWith(
        status: MusicStatus.error,
        errorMessage: failure.message,
      ),),
      (songs) => emit(state.copyWith(
        status: MusicStatus.success,
        songs: songs,
      ),),
    );
  }
}
