import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  Auth({
    @required this.googleSignIn,
  });

  final GoogleSignIn googleSignIn;

  Future<GoogleSignInAuthentication> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleAccount =
          await googleSignIn.signIn().catchError((onError) {
        print("error $onError");
        return null;
      });
      final GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;
      return googleAuth;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
