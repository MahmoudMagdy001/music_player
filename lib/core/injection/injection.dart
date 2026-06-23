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

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  getIt
    ..registerLazySingleton<CancelRequestService>(CancelRequestService.new)
    ..registerLazySingleton<InternetConnectionService>(InternetConnectionService.new)
    ..registerLazySingleton<AudioPlayer>(AudioPlayer.new)
    ..registerLazySingleton<CancelTokenInterceptor>(() => CancelTokenInterceptor(getIt()))
    ..registerLazySingleton<StabilityInterceptor>(() => StabilityInterceptor(getIt()))
    ..registerLazySingleton<AuthInterceptor>(AuthInterceptor.new)
    ..registerLazySingleton<Dio>(Dio.new)
    ..registerLazySingleton<DioService>(
      () => DioService(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
      ),
    );

  // Initialize modular DI components
  initDataSourceDependencies();
  initRepositoryDependencies();
  initUseCaseDependencies();
  initBlocDependencies();
}
