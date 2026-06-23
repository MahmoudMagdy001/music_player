import 'package:music_player/core/utils/app_logger.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeMusicService {
  final YoutubeExplode _yt = YoutubeExplode();

  /// Searches YouTube for a song and returns the direct audio stream URL.
  Future<String?> getAudioStreamUrl(String query) async {
    try {
      AppLogger.logInfo('YoutubeMusicService: Searching YouTube for "$query"');
      final searchResult = await _yt.search.search(query);
      if (searchResult.isEmpty) {
        AppLogger.logWarning('YoutubeMusicService: No search results found for "$query"');
        return null;
      }

      final video = searchResult.first;
      AppLogger.logInfo('YoutubeMusicService: Found video: "${video.title}" (${video.duration})');

      final manifest = await _yt.videos.streams.getManifest(video.id);
      final mp4Streams = manifest.audioOnly.where((e) => e.container == StreamContainer.mp4);
      final audioStream = mp4Streams.isNotEmpty
          ? mp4Streams.withHighestBitrate()
          : manifest.audioOnly.withHighestBitrate();
      return audioStream.url.toString();
    } on Object catch (e, stack) {
      AppLogger.logError('YoutubeMusicService: Failed to get audio stream URL for "$query": $e', e, stack);
      return null;
    }
  }

  void dispose() {
    _yt.close();
  }
}
