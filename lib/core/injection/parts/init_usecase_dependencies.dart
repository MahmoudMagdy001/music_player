import 'package:get_it/get_it.dart';
import 'package:music_player/features/music/domain/usecases/get_songs.dart';

void initUseCaseDependencies() {
  final getIt = GetIt.instance;
  getIt.registerLazySingleton<GetSongs>(() => GetSongs(getIt()));
}
