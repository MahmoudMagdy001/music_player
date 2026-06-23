import 'package:music_player/core/config/jamendo_config.dart';
import 'package:music_player/core/services/dio_service.dart';
import 'package:music_player/core/utils/app_logger.dart';
import 'package:music_player/core/utils/failures.dart';
import 'package:music_player/features/music/data/models/song_model.dart';

abstract class MusicRemoteDataSource {
  /// Fetches a list of tracks from Jamendo.
  ///
  /// [tags]   - Filter by genre/tag (e.g. 'rock', 'pop').
  /// [search] - Full-text search across track, album, and artist names.
  /// [lang]   - Filter by lyrics language (e.g. 'en', 'ar').
  /// [id]     - Filter by exact track ID(s), separated by spaces or plus.
  /// [limit]  - Max results to return (default: 50, max: 200).
  Future<List<SongModel>> getTracks({
    String? tags,
    String? search,
    String? lang,
    String? id,
    int limit = JamendoConfig.defaultLimit,
  });
}

class MusicRemoteDataSourceImpl implements MusicRemoteDataSource {
  final DioService _dio;

  MusicRemoteDataSourceImpl(this._dio);

  @override
  Future<List<SongModel>> getTracks({
    String? tags,
    String? search,
    String? lang,
    String? id,
    int limit = JamendoConfig.defaultLimit,
  }) async {
    // Use the search term, tags, or fall back to 'عمرو دياب' as the default query for Deezer search
    final queryText = (search != null && search.isNotEmpty)
        ? search
        : (tags != null && tags.isNotEmpty)
            ? tags
            : 'عمرو دياب';

    final queryParams = <String, dynamic>{
      'q': queryText,
      'limit': limit,
    };

    final result = await _dio.get<Map<String, dynamic>>(
      '${JamendoConfig.baseUrl}/search',
      queryParameters: queryParams,
    );

    return result.fold(
      (failure) {
        AppLogger.logError('MusicRemoteDataSource: getTracks failed → ${failure.message}');
        throw failure;
      },
      (response) {
        final data = response.data;
        if (data == null) throw const ServerFailure('Empty response from Deezer');

        final results = data['data']; // Deezer returns list in 'data'
        if (results == null || results is! List) {
          throw const ServerFailure('Invalid response format from Deezer');
        }

        return results
            .whereType<Map<String, dynamic>>()
            .map(SongModel.fromDeezerJson)
            .where((song) => song.audioPath.isNotEmpty) // only playable tracks
            .toList();
      },
    );
  }
}
