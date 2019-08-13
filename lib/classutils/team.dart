import 'package:flutter/material.dart';
import 'package:wasabee/classutils/dialog.dart';
import 'package:wasabee/pages/settingspage/constants.dart';
import 'package:wasabee/pages/teamspage/teamlistvm.dart';

class TeamUtils {
  static const TEAM_STATE_OFF = 'Off';
  static const TEAM_STATE_ON = 'On';

  static int getCountOfActive(List<TeamListViewModel> teamList) {
    return getActiveList(teamList).length;
  }

  static List<TeamListViewModel> getActiveList(List<TeamListViewModel> teamList) {
    return teamList == null
        ? List<TeamListViewModel>()
        : teamList.where((i) => i.teamState == TEAM_STATE_ON).toList();
  }

  static int getCountOfInactive(List<TeamListViewModel> teamList) {
    return getInactiveList(teamList).length;
  }

  static List<TeamListViewModel> getInactiveList(List<TeamListViewModel> teamList) {
    return teamList == null
        ? List<TeamListViewModel>()
        : teamList.where((i) => i.teamState == TEAM_STATE_OFF).toList();
  }

   static int getCountOfOwned(List<TeamListViewModel> teamList) {
    return getOwnedList(teamList).length;
  }

  static List<TeamListViewModel> getOwnedList(List<TeamListViewModel> teamList) {
    return teamList == null
        ? List<TeamListViewModel>()
        : teamList.where((i) => i.isOwned == true).toList();
  }

  static Widget getTeamInfoAlert(
      BuildContext context, TeamListViewModel vm) {
    List<Widget> dialogWidgets = <Widget>[
      Card(
          color: WasabeeConstants.CARD_COLOR,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "Team",
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
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ))
    ];
    
    return DialogUtils.wrapInDialog(dialogWidgets);
  }
}
