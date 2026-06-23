import 'package:fpdart/fpdart.dart';
import 'package:music_player/core/utils/failures.dart';
import 'package:music_player/features/music/domain/entities/song.dart';

abstract class MusicRepository {
  Future<Either<Failure, List<Song>>> getTracks({
    String? tags,
    String? search,
    String? lang,
    String? id,
  });

  /// Resolves the playable YouTube audio stream URL for a given [Song].
  Future<Either<Failure, String>> getAudioStreamUrl(Song song);
}
