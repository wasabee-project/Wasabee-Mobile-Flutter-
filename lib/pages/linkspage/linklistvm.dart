import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wasabee/network/responses/operationFullResponse.dart';

class LinkListViewModel {
  String titleString;

  LinkListViewModel({this.titleString});

  static List<LinkListViewModel> fromOperationData(
      List<Link> linkList,
      Map<String, Portal> portalMap,
      String googleId,
      LatLng mostRecentLoc,
      bool useImperialUnits) {
    var listOfVM = List<LinkListViewModel>();
    if (linkList != null && linkList.length > 0)
      for (var link in linkList) {
        var portal = portalMap[link.toPortalId];

        listOfVM.add(LinkListViewModel(titleString: "putLinkTitleHere"));
      }

    //TODO add sorting link list -> Longest link? alpha by to, alpha by from
    return listOfVM;
  }
}
