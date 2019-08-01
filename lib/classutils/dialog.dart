import 'package:flutter/material.dart';
import 'package:wasabee/network/networkcalls.dart';
import 'package:wasabee/network/urlmanager.dart';
import 'package:wasabee/pages/mappage/map.dart';
import 'package:wasabee/pages/settingspage/constants.dart';

class DialogUtils {
  static Widget getInfoAlertCommentWidget(String comment) {
    return Card(
        color: WasabeeConstants.CARD_COLOR,
        child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Text(
                  'Operator\'s Notes:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: WasabeeConstants.CARD_TEXT_COLOR),
                ),
                Container(
                  child: Text(
                    '$comment',
                    style: TextStyle(color: WasabeeConstants.CARD_TEXT_COLOR),
                  ),
                  margin: EdgeInsets.only(top: WasabeeConstants.MARGIN_SMALL),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            )));
  }

  static Widget addAssignedToWidget(String nickname) {
    return Card(
        color: WasabeeConstants.CARD_COLOR,
        child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Text(
                  'Agent Assigned:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: WasabeeConstants.CARD_TEXT_COLOR),
                ),
                Container(
                  child: Text('$nickname',
                      style:
                          TextStyle(color: WasabeeConstants.CARD_TEXT_COLOR)),
                  margin: EdgeInsets.only(top: WasabeeConstants.MARGIN_SMALL),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.stretch,
            )));
  }

  static List<Widget> getCompleteIncompleteButton(
      bool complete,
      String opId,
      BuildContext context,
      MapPageState mapPageState,
      String objectId,
      bool isMarker) {
    return <Widget>[
      Container(
          margin: EdgeInsets.only(left: 10.0, right: 10.0),
          child: RaisedButton(
              child: Row(
                children: <Widget>[
                  Container(
                    child: Icon(
                      complete ? Icons.cancel : Icons.sentiment_very_satisfied,
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.only(right: 10),
                  ),
                  Text(
                    complete ? 'Mark Incomplete' : 'Mark Complete',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              onPressed: () {
                var url = complete
                    ? isMarker
                        ? UrlManager.getInCompleteMarkerUrl(opId, objectId)
                        : UrlManager.getInCompleteLinkUrl(opId, objectId)
                    : isMarker
                        ? UrlManager.getCompleteMarkerUrl(opId, objectId)
                        : UrlManager.getCompleteLinkUrl(opId, objectId);
                doTargetDialogAction(url, context, mapPageState);
              },
              color: Colors.green)),
    ];
  }

  static doTargetDialogAction(
      String url, BuildContext context, MapPageState mapPageState) async {
    try {
      Navigator.of(context).pop();
      await mapPageState.updateVisibleRegion();
      NetworkCalls.doNetworkCall(url, Map<String, String>(),
          mapPageState.finishedTargetActionCall, false, NetWorkCallType.GET);
      mapPageState.setIsLoading();
    } catch (e) {
      mapPageState.setIsNotLoading();
      print(e);
    }
  }
}
