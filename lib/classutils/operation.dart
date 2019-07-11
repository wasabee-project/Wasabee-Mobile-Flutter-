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