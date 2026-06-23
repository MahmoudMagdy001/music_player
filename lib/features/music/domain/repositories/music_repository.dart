import 'package:fpdart/fpdart.dart';
import 'package:music_player/core/utils/failures.dart';
import 'package:music_player/features/music/domain/entities/song.dart';

abstract class MusicRepository {
  Future<Either<Failure, List<Song>>> getSongs();
}
