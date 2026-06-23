import 'package:get_it/get_it.dart';
import 'package:music_player/features/music/data/datasources/music_remote_datasource.dart';

void initDataSourceDependencies() {
  GetIt.instance.registerLazySingleton<MusicRemoteDataSource>(
    () => MusicRemoteDataSourceImpl(GetIt.instance()),
  );
}
