import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:wasabee/network/responses/meResponse.dart';
import 'package:wasabee/storage/localstorage.dart';
import 'auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../network/networkcalls.dart';
import '../mappage/map.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import '../../network/urlmanager.dart';
import '../../network/cookies.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = true;
  bool isInitialLoad = true;

  void callMe(String response) {
    var url = UrlManager.FULL_ME_URL;

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
    try {
      var meResponse = MeResponse.fromJson(json.decode(response));
      var googleId = meResponse.googleID;
      if (googleId != null) await LocalStorageUtils.storeGoogleId(googleId);
      var alertFilterType = await LocalStorageUtils.getAlertFilter();
      var alertSortType = await LocalStorageUtils.getAlertSort();
      var linkFilterType = await LocalStorageUtils.getLinkFilter();
      var linkSortType = await LocalStorageUtils.getLinkSort();
      var useImperialUnits = await LocalStorageUtils.getUseImperialUnits();
      var opList = meResponse.ops;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MapPage(
                ops: opList,
                googleId: googleId,
                alertFilterDropdownValue: alertFilterType,
                alertSortDropdownValue: alertSortType,
                linkFilterDropdownValue: linkFilterType,
                linkSortDropDownValue: linkSortType,
                useImperialUnitsValue: useImperialUnits)),
      );
    } catch (e) {
      await CookieUtils.clearAllCookies();
      setState(() {
        isLoading = false;
      });
      print("Exception In CallMe -> $e");
    }
  }

  Future<bool> checkPermissions() async {
    PermissionStatus locationPermission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    PermissionStatus filePermission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);

    var listOfPermissions = List<PermissionStatus>();
    listOfPermissions.add(locationPermission);
    listOfPermissions.add(filePermission);
    return findNonEnabled(listOfPermissions);
  }

  bool findNonEnabled(List<PermissionStatus> listOfPermStatuses) {
    var foundNonEnabled = false;
    print("listOfPermStatuses -> $listOfPermStatuses");
    if (listOfPermStatuses != null)
      for (var status in listOfPermStatuses) {
        if (status != PermissionStatus.granted) {
          if (!(Platform.isIOS && status == PermissionStatus.unknown))
            foundNonEnabled = true;
        }
      }
    return foundNonEnabled;
  }

  showNonEnabledDialog(BuildContext _context) {
    showDialog<void>(
      context: _context,
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
                requestPermissions(_context);
              },
            ),
          ],
        );
      },
    );
  }

  requestPermissions(BuildContext _context) async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions(
            [PermissionGroup.location, PermissionGroup.storage]);
    print('PERMISSION RESULTS: $permissions');
    if (findNonEnabled(permissions.values.toList())) {
      showNonEnabledDialog(_context);
    } else {
      initiateSignIn(_context);
    }
  }

  Future<bool> checkWasabeeCookie() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();

    var directory = await new Directory(appDocDirectory.path + '/' + 'cookies')
        .create(recursive: true);
    var cj = new PersistCookieJar(
      dir: directory.path,
      ignoreExpires: false,
    );
    return await CookieUtils.hasWasabeeCookie(cj);
  }

  @override
  Widget build(BuildContext context) {
    String titleString = " - Authenticate";
    if (isInitialLoad == true) {
      isInitialLoad = false;
      checkWasabeeCookie().then((foundCookie) {
        if (foundCookie) {
          print('FOUND COOKIE!');
          callMe(null);
        } else {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title + titleString),
        ),
        body: Builder(
            // Create an inner BuildContext so that the onPressed methods
            // can refer to the Scaffold with Scaffold.of().
            builder: (BuildContext context) {
          return Center(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : GoogleSignInButton(
                    onPressed: () {
                      checkPermissions().then((foundBad) {
                        if (foundBad) {
                          showNonEnabledDialog(context);
                        } else {
                          initiateSignIn(context);
                        }
                      });
                    },
                    darkMode: true),
          );
        }));
  }

  initiateSignIn(BuildContext _context) {
    setState(() {
      isLoading = true;
    });
    Auth(googleSignIn: GoogleSignIn())
        .signInWithGoogle(_context)
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
    var url = UrlManager.FULL_APTOK_URL;
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
