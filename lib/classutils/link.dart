import 'package:flutter/material.dart';
import 'package:wasabee/network/responses/operationFullResponse.dart';
import 'package:wasabee/pages/linkspage/linkfiltermanager.dart';
import 'package:wasabee/pages/linkspage/linklistvm.dart';
import 'package:wasabee/pages/mappage/map.dart';

class LinkUtils {
  static const DIVIDER_HEIGHT_DEFAULT = 25.0;

  static int getCountOfUnassigned(List<Link> linkList) {
    return getUnassignedList(linkList).length;
  }

  static List<Link> getUnassignedList(List<Link> linkList) {
    return linkList == null
        ? List<Link>()
        : linkList
            .where((i) => i.assignedTo?.isEmpty == true || i.assignedTo == null)
            .toList();
  }

  static int getCountOfMine(List<Link> linkList, String googleId) {
    return getMyList(linkList, googleId).length;
  }

  static List<Link> getMyList(List<Link> linkList, String googleId) {
    return linkList == null
        ? List<Link>()
        : linkList
            .where((i) =>
                i.assignedTo?.isNotEmpty == true && i.assignedTo == googleId)
            .toList();
  }

  static int getCountOfComplete(List<Link> linkList) {
    return getCompleteList(linkList).length;
  }

  static List<Link> getCompleteList(List<Link> linkList) {
    return linkList == null
        ? List<Link>()
        : linkList.where((i) => i.completed == true).toList();
  }

  static int getCountOfIncomplete(List<Link> linkList) {
    return getIncompleteList(linkList).length;
  }

  static List<Link> getIncompleteList(List<Link> linkList) {
    return linkList == null
        ? List<Link>()
        : linkList.where((i) => i.completed != true).toList();
  }

  static List<Link> getFilteredLinks(
      List<Link> linkList, LinkFilterType type, String googleId) {
    var returningList = List<Link>();
    switch (type) {
      case LinkFilterType.All:
        returningList = linkList;
        break;
      case LinkFilterType.Unassigned:
        returningList = getUnassignedList(linkList);
        break;
      case LinkFilterType.Mine:
        returningList = getMyList(linkList, googleId);
        break;
      case LinkFilterType.Complete:
        returningList = getCompleteList(linkList);
        break;
      case LinkFilterType.Incomplete:
        returningList = getIncompleteList(linkList);
        break;
    }
    return returningList;
  }

  static AlertDialog getLinkInfoAlert(
      BuildContext context, LinkListViewModel vm, String googleId) {
    //var fromPortal = vm.fromPortalId;
    //var toPortal = vm.toPortalId;
    List<Widget> dialogWidgets = <Widget>[
      Center(child: Text("${vm.fromPortalName} -> ${vm.toPortalName}")),
      Divider(color: Colors.green, height: DIVIDER_HEIGHT_DEFAULT),
    ];
    // dialogWidgets.add(getPortalIntelButton(fromPortal));
    // dialogWidgets.add(getPortalIntelButton(toPortal));
    // dialogWidgets.addAll(
    //     getCompleteIncompleteButton(target, opId, context, mapPageState));
    // if (vm.comment?.isNotEmpty == true)
    //   dialogWidgets.add(getInfoAlertCommentWidget(target));
    // if (target.assignedNickname?.isNotEmpty == true &&
    //     target.assignedTo != googleId)
    //   dialogWidgets.add(addAssignedToWidget(target));
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "Link",
                textAlign: TextAlign.center,
              )),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              color: Colors.transparent,
              child: IconButton(
                icon: Icon(Icons.close),
                color: Colors.black,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          )
        ],
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: dialogWidgets,
        ),
      ),
    );
  }
}
