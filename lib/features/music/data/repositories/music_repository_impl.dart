import 'package:fpdart/fpdart.dart';
import 'package:music_player/core/services/youtube_music_service.dart';
import 'package:music_player/core/utils/failures.dart';
import 'package:music_player/features/music/data/datasources/music_remote_datasource.dart';
import 'package:music_player/features/music/domain/entities/song.dart';
import 'package:music_player/features/music/domain/repositories/music_repository.dart';

class MusicRepositoryImpl implements MusicRepository {
  final MusicRemoteDataSource remoteDataSource;
  final YoutubeMusicService youtubeService;

  MusicRepositoryImpl(this.remoteDataSource, this.youtubeService);

  @override
  Future<Either<Failure, List<Song>>> getTracks({
    String? tags,
    String? search,
    String? lang,
    String? id,
  }) async {
    try {
      final models = await remoteDataSource.getTracks(
        tags: tags,
        search: search,
        lang: lang,
        id: id,
      );
      return Right(models);
    } on Object catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getAudioStreamUrl(Song song) async {
    try {
      final query = '${song.title} ${song.artist}';
      final streamUrl = await youtubeService.getAudioStreamUrl(query);
      if (streamUrl != null) {
        return Right(streamUrl);
      }
      
      // Fallback to original audioPath (e.g., Deezer preview) if YouTube resolution fails
      if (song.audioPath.isNotEmpty) {
        return Right(song.audioPath);
      }
      return const Left(ServerFailure('Could not resolve audio stream URL'));
    } on Object catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
