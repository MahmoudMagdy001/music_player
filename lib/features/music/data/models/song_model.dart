import 'package:music_player/features/music/domain/entities/song.dart';

class SongModel extends Song {
  const SongModel({
    required super.id,
    required super.title,
    required super.artist,
    required super.audioPath,
    required super.imageUrl,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) => SongModel(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      audioPath: json['audioPath'] as String,
      imageUrl: json['imageUrl'] as String,
    );

  Map<String, dynamic> toJson() => {
      'id': id,
      'title': title,
      'artist': artist,
      'audioPath': audioPath,
      'imageUrl': imageUrl,
    };
}
