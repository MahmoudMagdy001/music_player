import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/injection/injection.dart';
import 'package:music_player/features/music/presentation/bloc/music_bloc.dart';
import 'package:music_player/features/music/presentation/screens/home_screen.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _redirectCalled = false;

  @override
  void initState() {
    super.initState();
    unawaited(_checkInternetConnection());
  }

  Future<void> _checkInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      // Even if offline, we allow entering the app to listen to preloaded assets.
      await _redirect();
    } else {
      await _redirect();
    }
  }

  Future<void> _redirect() async {
    // Elegant delay to show splash logo
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (_redirectCalled || !mounted) {
      return;
    }

    _redirectCalled = true;
    unawaited(
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (context) => BlocProvider<MusicBloc>(
            create: (context) => getIt<MusicBloc>(),
            child: const HomeScreen(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1DB954), // Spotify Green
                Color(0xFF121212), // Spotify Black
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Placeholder / Splash branding
              Icon(
                Icons.music_note_rounded,
                size: 80.0,
                color: Colors.white.withValues(alpha: 0.9),
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      );
}
