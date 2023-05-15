// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:music_player/screens/auth_screen/data/google_signin.dart';
import 'package:music_player/screens/player_screen/music_list.dart';

import 'widgets/custom_button.dart';
import 'widgets/custom_text_form_field.dart';

class AuthModule extends StatefulWidget {
  const AuthModule({super.key});

  @override
  _AuthModule createState() => _AuthModule();
}

class _AuthModule extends State<AuthModule>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    emailController.dispose();
    emailControllerSignup.dispose();
    passwordController.dispose();
    passwordControllerSignup.dispose();
    nameControllerSignup.dispose();
    super.dispose();
  }

  final auth = FirebaseAuth.instance;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  GlobalKey<FormState> formkeylogin = GlobalKey<FormState>();

  TextEditingController emailControllerSignup = TextEditingController();
  TextEditingController passwordControllerSignup = TextEditingController();
  TextEditingController nameControllerSignup = TextEditingController();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool loading = false;

  bool isPasswordSignup = false;
  bool isPasswordLogin = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF144771),
        title: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          tabs: const [
            Tab(text: 'SIGN UP'),
            Tab(text: 'LOG IN'),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF144771),
              Color(0xFF071A2C),
            ],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        'Create your account.',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 15),
                      loading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 13,
                              ),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(
                                    width: 0.7,
                                    color: Colors.white,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                elevation: 0.0,
                                backgroundColor: Colors.transparent,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Logo(Logos.google),
                                  const SizedBox(width: 15),
                                  const Text(
                                    'Sign up with Google',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () async {
                                setState(() {
                                  loading = true;
                                });

                                UserCredential? userCredential =
                                    await handleSignIn();
                                if (userCredential != null) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AudioPlayerScreen(),
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    loading = false;
                                  });
                                }
                              },
                            ),
                      const SizedBox(height: 20),
                      Row(
                        children: const [
                          Expanded(
                            child: Divider(
                              color: Colors.white,
                              thickness: 0.5,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'or',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.white,
                              thickness: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      customTextFormField(
                        type: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please ENTER your name';
                          }
                          return null;
                        },
                        controller: nameControllerSignup,
                        label: 'Your name',
                        prefix: Icons.person,
                      ),
                      const SizedBox(height: 20.0),
                      customTextFormField(
                        type: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please ENTER your E-mail';
                          }
                          return null;
                        },
                        controller: emailControllerSignup,
                        label: 'E-Mail',
                        prefix: Icons.email,
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: passwordControllerSignup,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: isPasswordSignup,
                        onFieldSubmitted: (String value) {
                          if (kDebugMode) {
                            print(value);
                          }
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please ENTRE your password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                          suffixIcon: IconButton(
                            color: Colors.white,
                            icon: isPasswordSignup
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                            onPressed: () {
                              setState(() {
                                isPasswordSignup = !isPasswordSignup;
                              });
                            },
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 30),
                      loading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 13,
                              ),
                            )
                          : CustomButton(
                              label: 'SIGNUP',
                              onPressed: () {
                                if (formkey.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  _signUp();
                                  setState(() {
                                    loading = false;
                                  });
                                  _clearTexts();
                                }
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: formkeylogin,
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      const Text(
                        'Log in to your account.',
                        style: TextStyle(fontSize: 22.0, color: Colors.white),
                      ),
                      const SizedBox(height: 15),
                      loading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 13,
                              ),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(
                                        width: 0.7, color: Colors.white),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  elevation: 0.0,
                                  backgroundColor: Colors.transparent),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Logo(Logos.google),
                                  const SizedBox(width: 15),
                                  const Text(
                                    'Sign in with Google',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              onPressed: () async {
                                setState(() {
                                  loading = true;
                                });

                                UserCredential? userCredential =
                                    await handleSignIn();
                                if (userCredential != null) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AudioPlayerScreen(),
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    loading = false;
                                  });
                                }
                              },
                            ),
                      const SizedBox(height: 20),
                      Row(
                        children: const [
                          Expanded(
                            child: Divider(
                              color: Colors.white,
                              thickness: 0.5,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'or',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.white,
                              thickness: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      customTextFormField(
                        type: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'E-mail must not be empty';
                          }
                          return null;
                        },
                        controller: emailController,
                        label: 'E-mail',
                        prefix: Icons.email,
                      ),
                      const SizedBox(height: 15.0),
                      TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: isPasswordLogin,
                        onFieldSubmitted: (String value) {
                          if (kDebugMode) {
                            print(value);
                          }
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password must not be empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                          suffixIcon: IconButton(
                            color: Colors.white,
                            icon: isPasswordLogin
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                            onPressed: () {
                              setState(() {
                                isPasswordLogin = !isPasswordLogin;
                              });
                            },
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 30),
                      loading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 13,
                              ),
                            )
                          : CustomButton(
                              label: 'LOG IN',
                              onPressed: () {
                                if (formkeylogin.currentState!.validate()) {
                                  _login(context);
                                }
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearTexts() {
    nameControllerSignup.clear();
    passwordControllerSignup.clear();
    emailControllerSignup.clear();
  }

  Future<void> _login(BuildContext context) async {
    try {
      setState(() {
        loading = true;
      });
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      setState(() {
        loading = false;
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const AudioPlayerScreen(),
        ),
      );
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<void> _signUp() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailControllerSignup.text.trim(),
        password: passwordControllerSignup.text.trim(),
      )
          .then(
        (value) {
          value.user!.updateDisplayName(
            nameControllerSignup.text.trim(),
          );
        },
      );
      _showAlertDialogSignup(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Sign up"),
              content: const Text('The password provided is too weak.'),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else if (e.code == 'email-already-in-use') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Sign up"),
              content: const Text('The account already exists for that email.'),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void _showAlertDialogSignup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Sign up"),
          content: const Text("Sign up has been Successfully"),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
