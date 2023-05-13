// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sort_child_properties_last, library_private_types_in_public_api, unused_local_variable, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:music_player/screens/player_screen/music_list.dart';
import 'package:provider/provider.dart';

import 'widgets/custom_button.dart';
import 'widgets/custom_text_form_field.dart';
import 'data/google_signin.dart';

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
    super.dispose();
  }

  final auth = FirebaseAuth.instance;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  GlobalKey<FormState> formkeylogin = GlobalKey<FormState>();

  var emailControllerSignup = TextEditingController();
  var passwordControllerSignup = TextEditingController();
  var nameControllerSignup = TextEditingController();

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  bool loading = false;

  late String yourName;
  late String email;
  late String password;

  late String emaillogin;
  late String passwordlogin;

  bool isPasswordSignup = false;
  bool isPasswordLogin = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF144771),
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
                physics: BouncingScrollPhysics(),
                child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 15),
                      Text(
                        'Create your account.',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: Colors.white),
                      ),
                      SizedBox(height: 15),
                      loading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
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
                                final provider =
                                    Provider.of<GoogleSignInProvider>(context,
                                        listen: false);
                                setState(() {
                                  loading = true;
                                });
                                await provider.googleLogin();
                                setState(() {
                                  loading = false;
                                });
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => AudioPlayerScreen(),
                                  ),
                                );
                                // navigatePushReplacementTo(context, const HomeModel());
                              },
                            ),
                      SizedBox(height: 20),
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
                        onChange: (value) {
                          yourName = value;
                        },
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
                        onChange: (value) {
                          email = value;
                          if (kDebugMode) {
                            print(email);
                          }
                        },
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
                        onChanged: (value) {
                          password = value;
                          if (kDebugMode) {
                            print(password);
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
                          labelStyle: TextStyle(color: Colors.white),
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
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 30),
                      loading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : CustomButton(
                              label: 'SIGNUP',
                              onPressed: () async {
                                if (formkey.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  _signUp();
                                  setState(() {
                                    loading = false;
                                  });

                                  nameControllerSignup.text = '';
                                  passwordControllerSignup.text = '';
                                  emailControllerSignup.text = '';
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
                physics: BouncingScrollPhysics(),
                child: Form(
                  key: formkeylogin,
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      Text(
                        'Log in to your account.',
                        style: TextStyle(fontSize: 22.0, color: Colors.white),
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(width: 0.7, color: Colors.white),
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
                          final provider = Provider.of<GoogleSignInProvider>(
                              context,
                              listen: false);
                          setState(() {
                            loading = true;
                          });
                          await provider.googleLogin();
                          setState(() {
                            loading = false;
                          });
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => AudioPlayerScreen(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20),
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
                      SizedBox(height: 20),
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
                        onChange: (value) {
                          emaillogin = value;
                        },
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
                        onChanged: (value) {
                          passwordlogin = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password must not be empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white),
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
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 30),
                      loading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : CustomButton(
                              label: 'LOG IN',
                              onPressed: () async {
                                if (formkeylogin.currentState!.validate()) {
                                  try {
                                    setState(() {
                                      loading = true;
                                    });
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: emaillogin,
                                            password: passwordlogin);
                                    setState(() {
                                      loading = false;
                                    });

                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AudioPlayerScreen(),
                                      ),
                                    );

                                    // navigatePushReplacementTo(context, HomeModel());
                                  } catch (error) {
                                    if (kDebugMode) {
                                      print(error);
                                    }
                                  }
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

  void _signUp() async {
    try {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      _showAlertDialogSignup(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Sign up"),
              content: Text('The password provided is too weak.'),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        // print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Sign up"),
              content: Text('The account already exists for that email.'),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        // print('The account already exists for that email.');
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
          title: Text("Sign up"),
          content: Text("Sign up has been Successfully"),
          actions: [
            TextButton(
              child: Text("OK"),
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
