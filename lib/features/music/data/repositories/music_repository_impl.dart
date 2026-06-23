import 'package:fpdart/fpdart.dart';
import 'package:music_player/core/utils/failures.dart';
import 'package:music_player/features/music/data/datasources/music_local_datasource.dart';
import 'package:music_player/features/music/domain/entities/song.dart';
import 'package:music_player/features/music/domain/repositories/music_repository.dart';

class MusicRepositoryImpl implements MusicRepository {
  final MusicLocalDataSource localDataSource;

  MusicRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<Song>>> getSongs() async {
    try {
      final models = await localDataSource.getSongs();
      return Right(models);
    } on Object catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(LocalFailure(e.toString()));
    }
  }
}
