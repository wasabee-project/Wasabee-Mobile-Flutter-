import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wasabee/uihelpers/snackbarhelper.dart';

class Auth {
  Auth({
    @required this.googleSignIn,
  });

  final GoogleSignIn googleSignIn;

  Future<GoogleSignInAuthentication> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount googleAccount =
          await googleSignIn.signIn().catchError((onError) {
        print("error $onError");
        SnackBarHelper.showSnackBar(context, 'Google Auth Failed: Try Again');
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
