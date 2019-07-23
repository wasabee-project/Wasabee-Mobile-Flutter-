import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wasabee/network/responses/operationFullResponse.dart';

class LinkListViewModel {
  String fromPortalName;
  String toPortalName;
  int linkOrder;

  LinkListViewModel({this.fromPortalName, this.toPortalName, this.linkOrder});

  static List<LinkListViewModel> fromOperationData(
      List<Link> linkList,
      Map<String, Portal> portalMap,
      String googleId,
      LatLng mostRecentLoc,
      bool useImperialUnits) {
    var listOfVM = List<LinkListViewModel>();
    if (linkList != null && linkList.length > 0)
      for (var link in linkList) {
        var toPortal = portalMap[link.toPortalId];
        var fromPortal = portalMap[link.fromPortalId];
        if (fromPortal != null && toPortal != null) {
          var fromPortalName = "${fromPortal.name}";
          var toPortalName = "${toPortal.name}";
          listOfVM.add(LinkListViewModel(fromPortalName: fromPortalName, toPortalName: toPortalName, linkOrder: link.throwOrderPos));
        }
      }

    //TODO add sorting link list -> Longest link? alpha by to, alpha by from
    return listOfVM;
  }
}
