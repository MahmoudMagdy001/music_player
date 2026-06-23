import 'package:music_player/features/music/domain/entities/song.dart';

class SongModel extends Song {
  const SongModel({
    required super.id,
    required super.title,
    required super.artist,
    required super.audioPath,
    required super.imageUrl,
    super.albumName,
    super.duration,
    super.audiodownloadAllowed,
  });

  /// Maps a Jamendo API /tracks response item to [SongModel].
  ///
  /// Key Jamendo fields:
  /// - `name`        → title
  /// - `artist_name` → artist
  /// - `album_name`  → albumName
  /// - `audio`       → audioPath (stream URL, direct MP3)
  /// - `album_image` → imageUrl
  /// - `duration`    → duration (seconds, returned as int/string)
  /// - `audiodownload_allowed` → audiodownloadAllowed
  factory SongModel.fromJamendoJson(Map<String, dynamic> json) => SongModel(
        id: json['id']?.toString() ?? '',
        title: json['name']?.toString() ?? '',
        artist: json['artist_name']?.toString() ?? '',
        albumName: json['album_name']?.toString() ?? '',
        audioPath: json['audio']?.toString() ?? '',
        imageUrl: json['album_image']?.toString() ?? '',
        duration: int.tryParse(json['duration']?.toString() ?? '0') ?? 0,
        audiodownloadAllowed: json['audiodownload_allowed'] == true ||
            json['audiodownload_allowed'] == 'true',
      );

  /// Maps a Deezer API track search result item to [SongModel].
  factory SongModel.fromDeezerJson(Map<String, dynamic> json) {
    final artistMap = json['artist'] as Map<String, dynamic>?;
    final albumMap = json['album'] as Map<String, dynamic>?;

    return SongModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      artist: artistMap?['name']?.toString() ?? '',
      albumName: albumMap?['title']?.toString() ?? '',
      audioPath: json['preview']?.toString() ?? '',
      imageUrl: albumMap?['cover_medium']?.toString() ?? '',
      duration: int.tryParse(json['duration']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'artist': artist,
        'albumName': albumName,
        'audioPath': audioPath,
        'imageUrl': imageUrl,
        'duration': duration,
        'audiodownload_allowed': audiodownloadAllowed,
      };
}
