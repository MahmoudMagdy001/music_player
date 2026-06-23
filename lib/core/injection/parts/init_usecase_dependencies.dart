import 'package:get_it/get_it.dart';
import 'package:music_player/features/music/domain/usecases/get_audio_stream_url.dart';
import 'package:music_player/features/music/domain/usecases/get_songs.dart';

void initUseCaseDependencies() {
  final getIt = GetIt.instance;
  getIt
    ..registerLazySingleton<GetTracks>(() => GetTracks(getIt()))
    ..registerLazySingleton<GetAudioStreamUrl>(() => GetAudioStreamUrl(getIt()));
}
