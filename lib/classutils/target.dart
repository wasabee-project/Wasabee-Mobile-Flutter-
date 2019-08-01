import 'package:flutter/material.dart';
import 'package:wasabee/classutils/dialog.dart';
import 'package:wasabee/pages/alertspage/alertfiltermanager.dart';
import 'package:wasabee/pages/mappage/map.dart';
import 'package:wasabee/pages/mappage/markerutilities.dart';
import 'package:wasabee/network/networkcalls.dart';
import 'package:wasabee/network/responses/operationFullResponse.dart';
import 'package:wasabee/network/urlmanager.dart';
import 'package:wasabee/pages/settingspage/constants.dart';

class TargetUtils {
  static const DestroyPortalAlert = "DestroyPortalAlert";
  static const UseVirusPortalAlert = "UseVirusPortalAlert";
  static const LetDecayPortalAlert = "LetDecayPortalAlert";
  static const GetKeyPortalAlert = "GetKeyPortalAlert";
  static const LinkPortalAlert = "LinkPortalAlert";
  static const MeetAgentPortalAlert = "MeetAgentPortalAlert";
  static const OtherPortalAlert = "OtherPortalAlert";
  static const RechargePortalAlert = "RechargePortalAlert";
  static const UpgradePortalAlert = "UpgradePortalAlert";

  static const STATE_PENDING = "pending";
  static const STATE_ASSIGNED = "assigned";
  static const STATE_ACKNOWLEDGED = "acknowledged";
  static const STATE_COMPLETED = "completed";

  static String getDisplayType(Target target) {
    var displayType = "";
    switch (target.type) {
      case DestroyPortalAlert:
        displayType = "Destroy";
        break;
      case UseVirusPortalAlert:
        displayType = "Virus";
        break;
      case LetDecayPortalAlert:
        displayType = "Let Decay";
        break;
      case GetKeyPortalAlert:
        displayType = "Get Key";
        break;
      case LinkPortalAlert:
        displayType = "Link";
        break;
      case MeetAgentPortalAlert:
        displayType = "Meet Agent";
        break;
      case OtherPortalAlert:
        displayType = "Other";
        break;
      case RechargePortalAlert:
        displayType = "Recharge";
        break;
      case UpgradePortalAlert:
        displayType = "Upgrade";
        break;
    }
    return displayType;
  }

  static String getDisplayState(Target target, String googleId) {
    var displayState = "Pending";

    switch (target.state) {
      case STATE_PENDING:
        break;
      case STATE_ASSIGNED:
        if (googleId != null && target.assignedTo == googleId) {
          displayState = "Your Assignment";
        } else
          displayState = "Assigned";
        break;
      case STATE_ACKNOWLEDGED:
        if (googleId != null && target.assignedTo == googleId) {
          displayState = "Acknowledged Yours";
        } else
          displayState = "Acknowledged";
        break;
      case STATE_COMPLETED:
        displayState = "Completed";
        break;
    }
    return displayState;
  }

  static String getMarkerTitle(String portalName, Target target) {
    return "${getDisplayType(target)} - $portalName";
  }

  static Widget getTargetInfoAlert(
      BuildContext context,
      Portal portal,
      Target target,
      String googleId,
      String opId,
      MapPageState mapPageState,
      double maxWidth) {
    List<Widget> dialogWidgets = <Widget>[
      Card(
          color: WasabeeConstants.CARD_COLOR,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "Target - ${TargetUtils.getDisplayType(target)}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  )),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              )
            ],
          )),
      Card(
          color: WasabeeConstants.CARD_COLOR,
          child: Container(
              margin: EdgeInsets.all(WasabeeConstants.CARD_MARGIN),
              child: Column(
                children: <Widget>[
                  Center(
                      child: Text(
                    portal.name,
                    style: TextStyle(color: Colors.white),
                  )),
                  Divider(color: WasabeeConstants.CARD_COLOR),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Image.asset(
                        "assets/dialog_icons/${MarkerUtilities.getImagePath(target, googleId, MarkerUtilities.SEGMENT_ICON)}",
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.fitHeight,
                      ),
                      VerticalDivider(color: Colors.green),
                      Text(getDisplayState(target, googleId),
                          style: TextStyle(color: Colors.white))
                    ],
                  ),
                ],
              )))
    ];
    dialogWidgets.add(getOpenOnIntelButton(portal, maxWidth));
    if (target.assignedTo?.isNotEmpty == true &&
        target.assignedTo == googleId &&
        target.state == STATE_ASSIGNED)
      dialogWidgets
          .add(getAssignmentButtons(target, opId, context, mapPageState));
    dialogWidgets.addAll(DialogUtils.getCompleteIncompleteButton(
        target.state == STATE_COMPLETED,
        opId,
        context,
        mapPageState,
        target.iD,
        true));
    if (target.comment?.isNotEmpty == true)
      dialogWidgets.add(DialogUtils.getInfoAlertCommentWidget(target.comment));
    if (target.assignedNickname?.isNotEmpty == true &&
        target.assignedTo != googleId)
      dialogWidgets
          .add(DialogUtils.addAssignedToWidget(target.assignedNickname));
    return Container(
        color: Colors.grey[300],
        child: SingleChildScrollView(
          child: Column(
            children: dialogWidgets,
          ),
        ));
  }

  static Widget getOpenOnIntelButton(Portal portal, maxWidth) {
    return Container(
        constraints: BoxConstraints(minWidth: maxWidth),
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        child: RaisedButton(
          onPressed: () {
            UrlManager.launchIntelUrl(portal.lat, portal.lng);
          },
          child: Text(
            'Open On Intel',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.green,
        ));
  }

  static Widget getAssignmentButtons(Target target, String opId,
      BuildContext context, MapPageState mapPageState) {
    return Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Container(
                    margin: EdgeInsets.only(right: 2.5),
                    child: RaisedButton(
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Icon(
                                Icons.cancel,
                                color: Colors.white,
                              ),
                              margin: EdgeInsets.only(right: 10),
                            ),
                            Text(
                              'Reject',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                        ),
                        onPressed: () {
                          DialogUtils.doTargetDialogAction(
                              UrlManager.getRejectMarkerUrl(opId, target.iD),
                              context,
                              mapPageState);
                        },
                        color: Colors.green))),
            Expanded(
                child: Container(
                    margin: EdgeInsets.only(left: 2.5),
                    child: RaisedButton(
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              ),
                              margin: EdgeInsets.only(right: 10),
                            ),
                            Text(
                              'Accept',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                        ),
                        onPressed: () {
                          DialogUtils.doTargetDialogAction(
                              UrlManager.getAcknowledgeMarkerUrl(
                                  opId, target.iD),
                              context,
                              mapPageState);
                        },
                        color: Colors.green)))
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
        ));
  }

  static int getCountOfUnassigned(List<Target> targetList) {
    return getUnassignedList(targetList).length;
  }

  static List<Target> getUnassignedList(List<Target> targetList) {
    return targetList == null
        ? List<Target>()
        : targetList
            .where((i) => i.state == STATE_PENDING || i.state.isEmpty)
            .toList();
  }

  static int getCountOfMine(List<Target> targetList, String googleId) {
    return getMyList(targetList, googleId).length;
  }

  static List<Target> getMyList(List<Target> targetList, String googleId) {
    return targetList == null
        ? List<Target>()
        : targetList
            .where((i) =>
                i.assignedTo?.isNotEmpty == true && i.assignedTo == googleId)
            .toList();
  }

  static List<Target> getFilteredMarkers(
      List<Target> targetList, AlertFilterType type, String googleId) {
    var returningList = List<Target>();
    switch (type) {
      case AlertFilterType.All:
        returningList = targetList;
        break;
      case AlertFilterType.Unassigned:
        returningList = getUnassignedList(targetList);
        break;
      case AlertFilterType.Mine:
        returningList = getMyList(targetList, googleId);
        break;
    }
    return returningList;
  }
}
