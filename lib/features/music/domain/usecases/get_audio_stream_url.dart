import 'package:fpdart/fpdart.dart';
import 'package:music_player/core/utils/failures.dart';
import 'package:music_player/features/music/domain/entities/song.dart';
import 'package:music_player/features/music/domain/repositories/music_repository.dart';

class GetAudioStreamUrl {
  final MusicRepository repository;

  GetAudioStreamUrl(this.repository);

  Future<Either<Failure, String>> call(Song song) =>
      repository.getAudioStreamUrl(song);
}
