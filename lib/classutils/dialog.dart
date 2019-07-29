import 'package:flutter/material.dart';
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
                      fontWeight: FontWeight.bold, color: WasabeeConstants.CARD_TEXT_COLOR),
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
                  style: TextStyle(fontWeight: FontWeight.bold, color: WasabeeConstants.CARD_TEXT_COLOR),
                ),
                Container(
                  child: Text('$nickname', style: TextStyle(color: WasabeeConstants.CARD_TEXT_COLOR)),
                  margin: EdgeInsets.only(top: WasabeeConstants.MARGIN_SMALL),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            )));
  }
}
