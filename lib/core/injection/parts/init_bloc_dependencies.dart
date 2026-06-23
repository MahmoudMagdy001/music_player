import 'package:get_it/get_it.dart';
import 'package:music_player/features/music/presentation/bloc/music_bloc.dart';

void initBlocDependencies() {
  final getIt = GetIt.instance;
  getIt.registerFactory<MusicBloc>(() => MusicBloc(getIt()));
}
