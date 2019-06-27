import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:wasabee/network/responses/meResponse.dart';
import 'auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../network/networkcalls.dart';
import '../map/map.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String api = "https://server.wasabee.rocks";
  bool isLoading = false;

  void callMe(String response) {
    var url = api + "/me";

    try {
      NetworkCalls.doNetworkCall(url, Map<String, String>(), finishedCallMe,
          true, NetWorkCallType.GET);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  void finishedCallMe(String response) async {
    print('got me response -> $response');
    //TODO replace the assets/me.json with the response.
    String jsonResult =
        await rootBundle.loadString('assets/me.json');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MapPage(ops: MeResponse.fromJson(json.decode(jsonResult)).ops)),
    );
    setState(() {
      isLoading = false;
    });
  }

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
    var data = {
      'accessToken': '$accessToken',
    };

    try {
      NetworkCalls.doNetworkCall(
          url, data, callMe, false, NetWorkCallType.POST);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }
}
