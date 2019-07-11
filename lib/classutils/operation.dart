import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wasabee/map/utilities.dart';
import 'package:wasabee/network/responses/meResponse.dart';
import 'package:wasabee/network/responses/operationFullResponse.dart';

class OperationUtils {
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

  static Future<BitmapDescriptor> getIconFromColor(BuildContext context, Op operation) async {
    String path = 'assets/icons/groupa_2.bmp';
    switch (operation.color) {
      case "groupa":
        path = 'assets/icons/groupa_2.bmp';
        break;
      case "groupb":
        path = 'assets/icons/groupb.bmp';
        break;
      case "groupc":
        path = 'assets/icons/groupc.bmp';
        break;
      case "groupd":
        path = 'assets/icons/groupd.bmp';
        break;
      case "groupe":
        path = 'assets/icons/groupe.bmp';
        break;
      case "groupf":
        path = 'assets/icons/groupf.bmp';
        break;
    }
    final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
    return BitmapDescriptor.fromAssetImage(imageConfiguration, path);
  }

  static Portal getPortalFromID(String id, Operation operation) {
    for (var portal in operation.opportals) {
      if (portal.id == id) return portal;
    }
    return null;
  }

  static List<Link> getLinksForPortalId(String id, Operation operation) {
    var linkList = List<Link>();
    for (var link in operation.links) {
      if (link.fromPortalId == id || link.toPortalId == id) {
        linkList.add(link);
      }
    }
    return linkList;
  }
}