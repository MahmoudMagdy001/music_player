import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/core/injection/parts/init_bloc_dependencies.dart';
import 'package:music_player/core/injection/parts/init_datasource_dependencies.dart';
import 'package:music_player/core/injection/parts/init_repository_dependencies.dart';
import 'package:music_player/core/injection/parts/init_usecase_dependencies.dart';
import 'package:music_player/core/services/cancel_request_service.dart';
import 'package:music_player/core/services/dio_service.dart';
import 'package:music_player/core/services/internet_connection_service.dart';
import 'package:music_player/core/services/player_resolver_service.dart';
import 'package:music_player/core/services/youtube_music_service.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  getIt
    ..registerLazySingleton<CancelRequestService>(CancelRequestService.new)
    ..registerLazySingleton<InternetConnectionService>(
      InternetConnectionService.new,
    )
    ..registerLazySingleton<AudioPlayer>(
      () => AudioPlayer(
        userAgent:
            'com.google.android.youtube/20.10.38 (Linux; U; Android 11) gzip',
      ),
    )
    ..registerLazySingleton<YoutubeMusicService>(YoutubeMusicService.new)
    ..registerLazySingleton<CancelTokenInterceptor>(
      () => CancelTokenInterceptor(getIt()),
    )
    ..registerLazySingleton<StabilityInterceptor>(
      () => StabilityInterceptor(getIt()),
    )
    ..registerLazySingleton<AuthInterceptor>(AuthInterceptor.new)
    ..registerLazySingleton<Dio>(Dio.new)
    ..registerLazySingleton<DioService>(
      () => DioService(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton<PlayerResolverService>(
      () => PlayerResolverService(getIt(), getIt()),
    );

  // Initialize modular DI components
  initDataSourceDependencies();
  initRepositoryDependencies();
  initUseCaseDependencies();
  initBlocDependencies();

  // Eagerly instantiate PlayerResolverService to start listening to player stream
  getIt<PlayerResolverService>();
}
