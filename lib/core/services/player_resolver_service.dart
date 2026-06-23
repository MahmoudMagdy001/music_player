import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/core/utils/app_logger.dart';
import 'package:music_player/features/music/domain/entities/song.dart';
import 'package:music_player/features/music/domain/usecases/get_audio_stream_url.dart';

class PlayerResolverService {
  final AudioPlayer _player;
  final GetAudioStreamUrl _getAudioStreamUrl;

  // Track currently resolving song IDs to avoid duplicate queries
  final Set<String> _resolvingSongIds = {};

  PlayerResolverService(this._player, this._getAudioStreamUrl) {
    _player.currentIndexStream.listen(_onIndexChanged);
  }

  void _onIndexChanged(int? index) async {
    if (index == null) return;

    // Resolve current index if not already resolved
    await _resolveIndex(index);

    // Pre-resolve next index in the playlist
    final sequence = _player.sequence;
    if (index + 1 < sequence.length) {
      unawaited(_resolveIndex(index + 1));
    }
  }

  Future<void> _resolveIndex(int index) async {
    final sequence = _player.sequence;
    if (index >= sequence.length) return;

    final source = sequence[index];
    final tag = source.tag;
    if (tag is! MediaItem) return;

    final currentUri = (source as UriAudioSource).uri.toString();

    // Deezer preview URLs contain 'preview' or 'dzcdn.net'
    final isDeezerPreview =
        currentUri.contains('preview') || currentUri.contains('dzcdn.net');
    if (!isDeezerPreview) {
      // Already resolved to YouTube (or another source)
      return;
    }

    final songId = tag.id;
    if (_resolvingSongIds.contains(songId)) return;
    _resolvingSongIds.add(songId);

    AppLogger.logInfo(
      'PlayerResolverService: Resolving YouTube URL for index $index (${tag.title} - ${tag.artist})',
    );

    try {
      final song = Song(
        id: tag.id,
        title: tag.title,
        artist: tag.artist ?? '',
        audioPath: currentUri,
        imageUrl: tag.artUri?.toString() ?? '',
      );

      final result = await _getAudioStreamUrl(song);

      await result.fold(
        (failure) async {
          AppLogger.logWarning(
            'PlayerResolverService: Failed to resolve song $songId: ${failure.message}',
          );
        },
        (youtubeUrl) async {
          AppLogger.logInfo(
            'PlayerResolverService: Resolved YouTube stream for song $songId: $youtubeUrl',
          );

          // ignore: deprecated_member_use
          final playlist = _player.audioSource;
          AppLogger.logInfo('PlayerResolverService: playlist type is ${playlist.runtimeType}');
          
          final newSource = AudioSource.uri(
            Uri.parse(youtubeUrl),
            tag: tag,
          );

          // ignore: deprecated_member_use
          if (playlist is ConcatenatingAudioSource) {
            // Find current index of the song in the playlist dynamically
            final currentIndexInPlaylist = playlist.children.indexWhere(
              (source) =>
                  source is IndexedAudioSource &&
                  (source.tag as MediaItem?)?.id == tag.id,
            );

            if (currentIndexInPlaylist == -1) {
              AppLogger.logWarning(
                'PlayerResolverService: Song $songId (${tag.title}) is no longer in the playlist',
              );
              return;
            }

            // Safe replacement of source in the playlist
            final wasPlaying = _player.playing;
            final currentPosition = _player.position;
            final isActiveIndex = _player.currentIndex == currentIndexInPlaylist;

            await playlist.insert(currentIndexInPlaylist, newSource);
            await playlist.removeAt(currentIndexInPlaylist + 1);

            // If we replaced the active index, restore playback position
            if (isActiveIndex) {
              AppLogger.logInfo(
                'PlayerResolverService: Active item replaced. Seeking to $currentPosition at index $currentIndexInPlaylist',
              );
              await _player.seek(currentPosition, index: currentIndexInPlaylist);
              if (wasPlaying) {
                unawaited(_player.play());
              }
            } else {
              AppLogger.logInfo(
                'PlayerResolverService: Background item replaced at index $currentIndexInPlaylist. No seek required.',
              );
            }
          } else if (playlist is IndexedAudioSource) {
            // It's a single audio source (e.g. ProgressiveAudioSource)
            final sourceTag = playlist.tag;
            if (sourceTag is MediaItem && sourceTag.id == tag.id) {
              final wasPlaying = _player.playing;
              final currentPosition = _player.position;

              AppLogger.logInfo(
                'PlayerResolverService: Single audio source replaced. Seeking to $currentPosition',
              );

              await _player.setAudioSource(newSource);
              await _player.seek(currentPosition);
              if (wasPlaying) {
                unawaited(_player.play());
              }
            }
          }
        },
      );
    } on Object catch (e, stack) {
      AppLogger.logError(
        'PlayerResolverService: Error resolving song $songId: $e',
        e,
        stack,
      );
    } finally {
      _resolvingSongIds.remove(songId);
    }
  }
}
