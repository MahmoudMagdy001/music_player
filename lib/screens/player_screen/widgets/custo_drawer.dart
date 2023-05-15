// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../auth_screen/auth_screen.dart';
import '../../auth_screen/data/google_signin.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
    required this.user,
    required this.auth,
  });

  final User? user;
  final FirebaseAuth auth;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 15, 54, 90),
      elevation: 100,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF071A2C)),
            accountName: Text(
              user!.displayName ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              'Email: ${user!.email ?? ''}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              foregroundColor: Colors.white,
              radius: 40,
              backgroundImage: user!.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : const NetworkImage(
                      'https://previews.123rf.com/images/tuktukdesign/tuktukdesign1606/tuktukdesign160600119/59070200-user-icon-man-profil-homme-d-affaires-avatar-personne-ic%C3%B4ne-illustration-vectorielle.jpg',
                    ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.logout_outlined,
              color: Colors.red,
            ),
            title: const Text(
              'Log out',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              logOut(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> logOut(BuildContext context) async {
    try {
      await Future.wait(
        [
          auth.signOut(),
          logoutfromgoogle(),
        ],
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const AuthModule(),
      ),
    );
  }
}
