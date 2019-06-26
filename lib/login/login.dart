import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    String titleString = " - Authenticate";
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title + titleString),
        ),
        body: Center(
          child: GoogleSignInButton(
              onPressed: () {
                Auth(googleSignIn: GoogleSignIn()).signInWithGoogle().then(
                    (GoogleSignInAuthentication googleAuth) => print('Hi $googleAuth'));
              },
              darkMode: true),
        ));
  }

  doLogin() {}
}
