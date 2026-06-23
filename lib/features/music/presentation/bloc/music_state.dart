import 'package:equatable/equatable.dart';
import 'package:music_player/features/music/domain/entities/song.dart';

enum MusicStatus { initial, loading, success, error }

class MusicState extends Equatable {
  final MusicStatus status;
  final List<Song> songs;
  final String? errorMessage;

  const MusicState({
    required this.status,
    required this.songs,
    this.errorMessage,
  });

  factory MusicState.initial() => const MusicState(
        status: MusicStatus.initial,
        songs: [],
      );

  MusicState copyWith({
    MusicStatus? status,
    List<Song>? songs,
    String? errorMessage,
  }) => MusicState(
      status: status ?? this.status,
      songs: songs ?? this.songs,
      errorMessage: errorMessage ?? this.errorMessage,
    );

  @override
  List<Object?> get props => [status, songs, errorMessage];
}
