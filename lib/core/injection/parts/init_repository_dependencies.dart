import 'package:get_it/get_it.dart';
import 'package:music_player/features/music/data/repositories/music_repository_impl.dart';
import 'package:music_player/features/music/domain/repositories/music_repository.dart';

void initRepositoryDependencies() {
  final getIt = GetIt.instance;
  getIt.registerLazySingleton<MusicRepository>(() => MusicRepositoryImpl(getIt()));
}
