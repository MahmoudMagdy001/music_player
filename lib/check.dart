// ignore_for_file: library_private_types_in_public_api, unused_field

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_player/screens/auth_screen/auth_screen.dart';

import 'screens/player_screen/music_list.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _redirectCalled = false;
  String? _connectionStatus;

  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    if (_redirectCalled || !mounted) {
      return;
    }

    _redirectCalled = true;
    final auth = FirebaseAuth.instance.currentUser;
    if (auth != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const AudioPlayerScreen(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const AuthModule(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF144771),
              Color.fromARGB(255, 10, 35, 59),
            ],
          ),
        ),
        child: const Center(
            child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 12,
        )),
      ),
    );
  }
}
