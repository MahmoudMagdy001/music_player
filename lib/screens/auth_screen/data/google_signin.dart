// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<UserCredential?> handleSignIn() async {
  try {
    // Trigger the Google authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // Obtain the Google Authentication object
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential using the Google ID token and access token
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with the credential
    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    // Return the user credentials
    return userCredential;
  } catch (error) {
    // Handle any errors that occur during the sign-in process
    print('Error signing in with Google: $error');
    return null;
  }
}

Future logoutfromgoogle() async {
  await _googleSignIn.disconnect();
  FirebaseAuth.instance.signOut();
}
