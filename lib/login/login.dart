import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'auth.dart';
import '../map/map.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert' as convert;
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import '../network/cookies.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String api = "https://server.wasabee.rocks";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    String titleString = " - Authenticate";
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title + titleString),
        ),
        body: Center(
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : GoogleSignInButton(
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
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
      CookieUtils.saveWasabeeCookieFromList(cookieList, cm);

      // print('cookies are -> $cookieList');
      // print(response);
      if (response.statusCode == 200)
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (BuildContext context) => MapPage()));
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }
}
