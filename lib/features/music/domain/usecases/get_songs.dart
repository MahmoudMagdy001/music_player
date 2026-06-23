import 'package:fpdart/fpdart.dart';
import 'package:music_player/core/utils/failures.dart';
import 'package:music_player/features/music/domain/entities/song.dart';
import 'package:music_player/features/music/domain/repositories/music_repository.dart';

class GetSongs {
  final MusicRepository repository;

  GetSongs(this.repository);

  Future<Either<Failure, List<Song>>> call() async => repository.getSongs();
}
