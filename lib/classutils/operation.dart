import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wasabee/pages/loginpage/login.dart';
import 'package:wasabee/pages/mappage/utilities.dart';
import 'package:wasabee/network/cookies.dart';
import 'package:wasabee/network/responses/meResponse.dart';
import 'package:wasabee/network/responses/operationFullResponse.dart';

import '../main.dart';

class OperationUtils {
  static Map<String, Portal> getPortalMap(List<Portal> portalList) {
    Map<String, Portal> portalMap = Map<String, Portal>();
    for (var portal in portalList) portalMap[portal.id] = portal;
    return portalMap;
  }

  static Color getLinkColor(Op operation) {
    String hexString = "";
    switch (operation.color) {
      case "groupa":
        hexString = 'ff6600';
        break;
      case "groupb":
        hexString = 'ff9900';
        break;
      case "groupc":
        hexString = 'BB9900';
        break;
      case "groupd":
        hexString = 'bb22cc';
        break;
      case "groupe":
        hexString = '33cccc';
        break;
      case "groupf":
        hexString = 'ff55ff';
        break;
    }
    return HexColor(hexString);
  }

  static Portal getPortalFromID(String id, Operation operation) {
    for (var portal in operation.opportals) {
      if (portal.id == id) return portal;
    }
    return null;
  }

  static List<Link> getLinksForPortalId(String id, Operation operation) {
    var linkList = List<Link>();
    if (operation.links != null)
      for (var link in operation.links) {
        if (link.fromPortalId == id || link.toPortalId == id) {
          linkList.add(link);
        }
      }
    return linkList;
  }

  static AlertDialog getParsingOperationFailedDialog(
      BuildContext context, String operationName) {
    return AlertDialog(
      title: Text('Parsing Op Failed!'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
                'Either parsing the operation$operationName failed or your auth token expired.  You must login again to continue.  If you\'ve seen this message within 5 minutes, check the operation you\'re trying to load.'),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
            CookieUtils.clearAllCookies().then((completed) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginPage(
                          title: MyApp.APP_TITLE,
                        )),
              );
            });
          },
        ),
      ],
    );
  }

  static AlertDialog getRefreshOpListDialog(BuildContext context) {
    return AlertDialog(
      title: Text('Refresh Op List?'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Are you sure you want to refresh your operation list?'),
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginPage(
                        title: MyApp.APP_TITLE,
                      )),
            );
          },
        ),
      ],
    );
  }
}
