import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/core/injection/injection.dart';
import 'package:music_player/features/music/presentation/bloc/music_bloc.dart';
import 'package:music_player/features/music/presentation/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await initDependencies();

  // Set system UI styling
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFF121212),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Set preferred device orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        designSize:
            const Size(375, 812), // Premium design canvas (iPhone X size)
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Music Player',
          theme: ThemeData.dark().copyWith(
            primaryColor: const Color(0xFF1DB954),
            scaffoldBackgroundColor: const Color(0xFF121212),
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF1DB954),
              surface: Color(0xFF1E1E1E),
              error: Color(0xFFE91E63),
            ),
          ),
          home: child,
        ),
        child: BlocProvider<MusicBloc>(
          create: (context) => getIt<MusicBloc>(),
          child: const HomeScreen(),
        ),
      );
}
