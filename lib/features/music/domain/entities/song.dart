import 'package:equatable/equatable.dart';

class Song extends Equatable {
  final String id;
  final String title;
  final String artist;
  final String albumName;
  final String audioPath;
  final String imageUrl;
  final int duration; // in seconds
  final bool audiodownloadAllowed;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.audioPath,
    required this.imageUrl,
    this.albumName = '',
    this.duration = 0,
    this.audiodownloadAllowed = false,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        artist,
        albumName,
        audioPath,
        imageUrl,
        duration,
        audiodownloadAllowed,
      ];
}
