import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert' as convert;
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String api = "https://server.wasabee.rocks";

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
                    (GoogleSignInAuthentication googleAuth) =>
                        doLogin(googleAuth.accessToken));
              },
              darkMode: true),
        ));
  }

  doLogin(String accessToken) async {
    var url = api + "/aptok";
    String sendData = convert.jsonEncode({
      'accessToken': '$accessToken',
    });

    print('URL: $url');
    print('sendData: $sendData');
    try {
      var dio = new Dio();
      var cj = CookieJar();
      var cm = CookieManager(cj);
      dio.interceptors.add(cm);

      Response response = await dio.post(url, data: sendData);
      var cookieList = cj.loadForRequest(Uri.parse(url));
      print('cookies are -> $cookieList');
      print(response);
    } catch (e) {
      print(e);
    }
  }
}
