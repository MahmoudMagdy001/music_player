import 'package:equatable/equatable.dart';

class Song extends Equatable {
  final String id;
  final String title;
  final String artist;
  final String audioPath;
  final String imageUrl;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.audioPath,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, title, artist, audioPath, imageUrl];
}
