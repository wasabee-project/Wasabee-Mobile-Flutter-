import 'package:flutter/material.dart';
import 'package:wasabee/map/markerutilities.dart';
import 'package:wasabee/network/responses/operationFullResponse.dart';

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

  static const MARGIN_DEFAULT = 8.0;
  static const MARGIN_SMALL = 4.0;

  static const DIVIDER_HEIGHT_DEFAULT = 25.0;

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

  static AlertDialog getTargetInfoAlert(
      BuildContext context, Portal portal, Target target, String googleId) {
    List<Widget> dialogWidgets = <Widget>[
      Center(child: Text(portal.name)),
      Divider(color: Colors.green, height: DIVIDER_HEIGHT_DEFAULT),
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
          Text(getDisplayState(target, googleId))
        ],
      ),
      Divider(color: Colors.green, height: DIVIDER_HEIGHT_DEFAULT),
    ];
    if (target.assignedTo?.isNotEmpty == true && target.assignedTo == googleId)
      dialogWidgets.add(getCompleteIncompleteButton(target));
    if (target.comment?.isNotEmpty == true)
      dialogWidgets.add(getInfoAlertCommentWidget(target));
    return AlertDialog(
      title:
          Center(child: Text("Target - ${TargetUtils.getDisplayType(target)}")),
      content: SingleChildScrollView(
        child: ListBody(
          children: dialogWidgets,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  static Widget getInfoAlertCommentWidget(Target target) {
    return Column(
      children: <Widget>[
        Text(
          'Operator\'s Notes:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Container(
          child: Text('${target.comment}'),
          margin: EdgeInsets.only(top: MARGIN_SMALL),
        )
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  static Widget getCompleteIncompleteButton(Target target) {
    return Column(
      children: <Widget>[
        RaisedButton(
            child: Text(
              target.state == STATE_COMPLETED
                  ? 'Mark Incomplete'
                  : 'Mark Complete',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              //TODO make this do something
            },
            color: Colors.green),
        Divider(color: Colors.green, height: DIVIDER_HEIGHT_DEFAULT),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }
}
