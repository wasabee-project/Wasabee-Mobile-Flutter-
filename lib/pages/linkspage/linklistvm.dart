import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wasabee/location/distanceutilities.dart';
import 'package:wasabee/location/locationhelper.dart';
import 'package:wasabee/network/responses/operationFullResponse.dart';
import 'package:wasabee/pages/linkspage/linksortdialog.dart';

class LinkListViewModel {
  String fromPortalName;
  String toPortalName;
  int linkOrder;
  double length;
  String lengthString;
  bool completed;
  String fromPortalId;
  String toPortalId;
  String comment;
  String assignedNickname;
  String assignedTo;

  LinkListViewModel(
      {this.fromPortalName,
      this.toPortalName,
      this.linkOrder,
      this.length,
      this.lengthString,
      this.completed,
      this.fromPortalId,
      this.toPortalId,
      this.comment,
      this.assignedNickname,
      this.assignedTo});

  static List<LinkListViewModel> fromOperationData(
      List<Link> linkList,
      Map<String, Portal> portalMap,
      String googleId,
      LinkSortType sortType,
      bool useImperialUnits) {
    var listOfVM = List<LinkListViewModel>();
    if (linkList != null && linkList.length > 0)
      for (var link in linkList) {
        var toPortal = portalMap[link.toPortalId];
        var fromPortal = portalMap[link.fromPortalId];
        if (fromPortal != null && toPortal != null) {
          LatLng fromPortalLoc = LocationHelper.getPortalLoc(fromPortal);
          LatLng toPortalLoc = LocationHelper.getPortalLoc(toPortal);

          var fromPortalName = "${fromPortal.name}";
          var toPortalName = "${toPortal.name}";
          var distanceDouble = DistanceUtilities.getDistanceDouble(
              fromPortalLoc, toPortalLoc, useImperialUnits);
          var distanceString = fromPortalLoc == null || toPortalLoc == null
                  ? ""
                  : "Length: ${DistanceUtilities.getDistanceString(
                      distanceDouble, useImperialUnits)}";
          listOfVM.add(LinkListViewModel(
              fromPortalName: fromPortalName,
              toPortalName: toPortalName,
              linkOrder: link.throwOrderPos,
              length: distanceDouble,
              lengthString: distanceString,
              completed: link.completed,
              fromPortalId: fromPortal.id,
              toPortalId: toPortal.id,
              comment: link.description,
              assignedNickname: link.assignedNickname,
              assignedTo: link.assignedTo));
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
