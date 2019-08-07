import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wasabee/classutils/operation.dart';
import 'package:wasabee/location/distanceutilities.dart';
import 'package:wasabee/location/locationhelper.dart';
import 'package:wasabee/network/responses/operationFullResponse.dart';
import 'package:wasabee/pages/linkspage/linksortdialog.dart';
import 'package:wasabee/pages/mappage/utilities.dart';

class LinkListViewModel {
  String fromPortalName;
  String toPortalName;
  int linkOrder;
  double length;
  double lengthMeters;
  String lengthString;
  bool completed;
  String fromPortalId;
  String toPortalId;
  String comment;
  String assignedNickname;
  String assignedTo;
  String opId;
  String linkId;
  double portalReqLevel;
  Color portalReqColor;

  LinkListViewModel(
      {this.fromPortalName,
      this.toPortalName,
      this.linkOrder,
      this.length,
      this.lengthMeters,
      this.lengthString,
      this.completed,
      this.fromPortalId,
      this.toPortalId,
      this.comment,
      this.assignedNickname,
      this.assignedTo,
      this.opId,
      this.linkId,
      this.portalReqLevel,
      this.portalReqColor});

  static Future<List<LinkListViewModel>> fromOperationData(
      List<Link> linkList,
      Map<String, Portal> portalMap,
      String googleId,
      LinkSortType sortType,
      bool useImperialUnits,
      String opId) async {
    var listOfVM = List<LinkListViewModel>();
    if (linkList != null && linkList.length > 0)
      for (var link in linkList) {
        var toPortal = portalMap[link.toPortalId];
        var fromPortal = portalMap[link.fromPortalId];
        if (fromPortal?.lat != null &&
            fromPortal?.lng != null &&
            toPortal?.lat != null &&
            toPortal?.lng != null) {
          LatLng fromPortalLoc = LocationHelper.getPortalLoc(fromPortal);
          LatLng toPortalLoc = LocationHelper.getPortalLoc(toPortal);

          var fromPortalName = "${fromPortal.name}";
          var toPortalName = "${toPortal.name}";
          var distanceMeters = await DistanceUtilities.getDistanceMeters(
              fromPortalLoc, toPortalLoc);
          var distanceDouble = DistanceUtilities.getDistanceDouble(
              useImperialUnits, distanceMeters);
          var distanceString =
              "${DistanceUtilities.getDistanceString(distanceDouble, useImperialUnits)}";
          var portalReqLevel = MapUtilities.getPortalLevel(distanceMeters);
          var portalReqColor =
              OperationUtils.getPortalLevelColor(portalReqLevel);
          listOfVM.add(LinkListViewModel(
              fromPortalName: fromPortalName,
              toPortalName: toPortalName,
              linkOrder: link.throwOrderPos,
              length: distanceDouble,
              lengthMeters: distanceMeters,
              lengthString: distanceString,
              completed: link.completed,
              fromPortalId: fromPortal.id,
              toPortalId: toPortal.id,
              comment: link.description,
              assignedNickname: link.assignedNickname,
              assignedTo: link.assignedTo,
              opId: opId,
              linkId: link.iD,
              portalReqLevel: portalReqLevel,
              portalReqColor: portalReqColor));
        }
      }

    listOfVM = sortLinkVMsByOrder(listOfVM);
    listOfVM = sortFromType(sortType, listOfVM);
    return listOfVM;
  }

  static List<LinkListViewModel> sortFromType(
      LinkSortType type, List<LinkListViewModel> list) {
    switch (type) {
      case LinkSortType.AlphaFromPortal:
        list = sortLinkVMsByFromPortalName(list);
        break;
      case LinkSortType.AlphaToPortal:
        list = sortLinkVMsByToPortalName(list);
        break;
      case LinkSortType.LinkLength:
        list = sortLinkVMsByLength(list);
        break;
      case LinkSortType.LinkOrder:
        break;
    }
    return list;
  }

  static List<LinkListViewModel> sortLinkVMsByOrder(
      List<LinkListViewModel> listOfVM) {
    listOfVM.sort((a, b) => a.linkOrder.compareTo(b.linkOrder));
    return listOfVM;
  }

  static List<LinkListViewModel> sortLinkVMsByFromPortalName(
      List<LinkListViewModel> listOfVM) {
    listOfVM.sort((a, b) => a.fromPortalName.compareTo(b.fromPortalName));
    return listOfVM;
  }

  static List<LinkListViewModel> sortLinkVMsByToPortalName(
      List<LinkListViewModel> listOfVM) {
    listOfVM.sort((a, b) => a.toPortalName.compareTo(b.toPortalName));
    return listOfVM;
  }

  static List<LinkListViewModel> sortLinkVMsByLength(
      List<LinkListViewModel> listOfVM) {
    listOfVM.sort((a, b) => a.length.compareTo(b.length));
    return listOfVM;
  }
}
