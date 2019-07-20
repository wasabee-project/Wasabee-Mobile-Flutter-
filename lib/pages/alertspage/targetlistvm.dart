import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wasabee/classutils/target.dart';
import 'package:wasabee/network/responses/operationFullResponse.dart';
import 'package:wasabee/pages/alertspage/alertsortdialog.dart';
import '../mappage/markerutilities.dart';

class TargetListViewModel {
  String targetId;
  String titleString;
  String stateString;
  double distanceDouble;
  String distanceString;
  String imagePath;
  LatLng latLng;
  String targetType;
  String targetState;
  String targetPortalName;

  TargetListViewModel(
      {this.targetId,
      this.titleString,
      this.stateString,
      this.distanceDouble,
      this.distanceString,
      this.imagePath,
      this.latLng,
      this.targetType,
      this.targetState,
      this.targetPortalName});

  static List<TargetListViewModel> fromOperationData(
      List<Target> targetList,
      Map<String, Portal> portalMap,
      String googleId,
      LatLng mostRecentLoc,
      AlertSortType sortType) {
    var listOfVM = List<TargetListViewModel>();
    if (targetList != null && targetList.length > 0)
      for (var target in targetList) {
        var portal = portalMap[target.portalId];
        LatLng portalLoc;
        if (portal.lat?.isNotEmpty == true && portal.lng?.isNotEmpty == true) {
          portalLoc =
              LatLng(double.parse(portal.lat), double.parse(portal.lng));
        }
        var distanceDouble =
            MarkerUtilities.getDistanceDouble(portalLoc, mostRecentLoc);
        var unitsString = "km";
        listOfVM.add(TargetListViewModel(
            targetId: target.iD,
            titleString: TargetUtils.getMarkerTitle(portal.name, target),
            stateString: TargetUtils.getDisplayState(target, googleId),
            distanceDouble: distanceDouble,
            distanceString:
                mostRecentLoc == null ? "" : "$distanceDouble $unitsString",
            imagePath:
                "assets/dialog_icons/${MarkerUtilities.getImagePath(target, googleId, MarkerUtilities.SEGMENT_ICON)}",
            latLng: portalLoc,
            targetType: target.type,
            targetState: target.state,
            targetPortalName: portal.name));
      }
    listOfVM = sortAlertVMsByDistance(listOfVM);
    listOfVM = sortFromType(sortType, listOfVM);
    return listOfVM;
  }

  static List<TargetListViewModel> sortFromType(
      AlertSortType type, List<TargetListViewModel> list) {
    switch (type) {
      case AlertSortType.AlphaName:
        list = sortAlertVMsByPortalName(list);
        break;
      case AlertSortType.CurrentState:
        list = sortAlertVMsByState(list);
        break;
      case AlertSortType.Distance:
        list = sortAlertVMsByDistance(list);
        break;
      case AlertSortType.TargetType:
        list = sortAlertVMsByType(list);
        break;
    }
    return list;
  }

  static List<TargetListViewModel> sortAlertVMsByDistance(
      List<TargetListViewModel> listOfVM) {
    listOfVM.sort((a, b) => a.distanceDouble.compareTo(b.distanceDouble));
    return listOfVM;
  }

  static List<TargetListViewModel> sortAlertVMsByType(
      List<TargetListViewModel> listOfTargets) {
    listOfTargets.sort((a, b) =>
        a.titleString.toLowerCase().compareTo(b.titleString.toLowerCase()));
    return listOfTargets;
  }

  static List<TargetListViewModel> sortAlertVMsByPortalName(
      List<TargetListViewModel> listOfTargets) {
    listOfTargets.sort((a, b) => a.targetPortalName
        .toLowerCase()
        .compareTo(b.targetPortalName.toLowerCase()));
    return listOfTargets;
  }

  static List<TargetListViewModel> sortAlertVMsByState(
      List<TargetListViewModel> listOfTargets) {
    listOfTargets.sort((a, b) =>
        a.targetState.toLowerCase().compareTo(b.targetState.toLowerCase()));
    return listOfTargets;
  }
}
