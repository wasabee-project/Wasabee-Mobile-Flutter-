import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wasabee/classutils/target.dart';
import 'package:wasabee/network/responses/operationFullResponse.dart';
import '../mappage/markerutilities.dart';

class TargetListViewModel {
  String targetId;
  String titleString;
  String stateString;
  double distanceDouble;
  String distanceString;
  String imagePath;
  LatLng latLng;

  TargetListViewModel(
      {this.targetId,
      this.titleString,
      this.stateString,
      this.distanceDouble,
      this.distanceString,
      this.imagePath,
      this.latLng});

  static List<TargetListViewModel> fromOperationData(List<Target> targetList,
      Map<String, Portal> portalMap, String googleId, LatLng mostRecentLoc) {
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
            MarkerUtilities.getDistanceString(portalLoc, mostRecentLoc);
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
            latLng: portalLoc));
      }

    //TODO get sort type and sort based on that.
    return sortTargetListVMList(listOfVM);
  }

  static List<TargetListViewModel> sortTargetListVMList(
      List<TargetListViewModel> listOfVM) {
    listOfVM.sort((a, b) => a.distanceDouble.compareTo(b.distanceDouble));
    return listOfVM;
  }
}
