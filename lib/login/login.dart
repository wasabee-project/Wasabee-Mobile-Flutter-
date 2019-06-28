import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:wasabee/network/responses/meResponse.dart';
import 'auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../network/networkcalls.dart';
import '../map/map.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              MapPage(ops: MeResponse.fromJson(json.decode(response)).ops)),
    );
    setState(() {
      isLoading = false;
    });
  }

  Future<bool> checkPermissions() async {
    ServiceStatus locationStatus =
        await PermissionHandler().checkServiceStatus(PermissionGroup.location);
    ServiceStatus localFileStatus =
        await PermissionHandler().checkServiceStatus(PermissionGroup.storage);

    var listOfStatuses = List<ServiceStatus>();
    listOfStatuses.add(localFileStatus);
    listOfStatuses.add(locationStatus);
    return findNonEnabled(listOfStatuses, null);
  }

  bool findNonEnabled(List<ServiceStatus> listOfStatuses,
      List<PermissionStatus> listOfPermStatuses) {
    var foundNonEnabled = false;
    print("listOfStatuses -> $listOfStatuses");
    print("listOfPermStatuses -> $listOfPermStatuses");
    if (listOfStatuses != null)
      for (var status in listOfStatuses) {
        if (status != ServiceStatus.enabled &&
            status != ServiceStatus.notApplicable) foundNonEnabled = true;
      }
    if (listOfPermStatuses != null)
      for (var status in listOfPermStatuses) {
        if (status != PermissionStatus.granted) foundNonEnabled = true;
      }
    return foundNonEnabled;
  }

  showNonEnabledDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('You\'re Missing Permissions!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You must accept all permissions to run Wasabee Mobile'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                requestPermissions();
              },
            ),
          ],
        );
      },
    );
  }

  requestPermissions() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions(
            [PermissionGroup.location, PermissionGroup.storage]);
    print('PERMISSION RESULTS: $permissions');
    if (findNonEnabled(null, permissions.values.toList())) {
      showNonEnabledDialog();
    } else {
      initiateSignIn();
    }
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
                    checkPermissions().then((foundBad) {
                      if (foundBad) {
                        showNonEnabledDialog();
                      } else {
                        initiateSignIn();
                      }
                    });
                  },
                  darkMode: true),
        ));
  }

  initiateSignIn() {
    setState(() {
      isLoading = true;
    });
    Auth(googleSignIn: GoogleSignIn())
        .signInWithGoogle()
        .then((GoogleSignInAuthentication googleAuth) {
      if (googleAuth == null) {
        setState(() {
          isLoading = false;
        });
      } else {
        doLogin(googleAuth.accessToken);
      }
    });
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
