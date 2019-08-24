import 'package:flutter/material.dart';
import 'package:wasabee/classutils/dialog.dart';
import 'package:wasabee/network/responses/teamResponse.dart';
import 'package:wasabee/pages/settingspage/constants.dart';
import 'package:wasabee/pages/teamspage/team.dart';
import 'package:wasabee/pages/teamspage/teamdialogvm.dart';
import 'package:wasabee/pages/teamspage/teamlistvm.dart';
import 'package:transparent_image/transparent_image.dart';

class TeamUtils {
  static const TEAM_STATE_OFF = 'Off';
  static const TEAM_STATE_ON = 'On';

  static int getCountOfActive(List<TeamListViewModel> teamList) {
    return getActiveList(teamList).length;
  }

  static List<TeamListViewModel> getActiveList(
      List<TeamListViewModel> teamList) {
    return teamList == null
        ? List<TeamListViewModel>()
        : teamList.where((i) => i.teamState == TEAM_STATE_ON).toList();
  }

  static int getCountOfInactive(List<TeamListViewModel> teamList) {
    return getInactiveList(teamList).length;
  }

  static List<TeamListViewModel> getInactiveList(
      List<TeamListViewModel> teamList) {
    return teamList == null
        ? List<TeamListViewModel>()
        : teamList.where((i) => i.teamState == TEAM_STATE_OFF).toList();
  }

  static int getCountOfOwned(List<TeamListViewModel> teamList) {
    return getOwnedList(teamList).length;
  }

  static List<TeamListViewModel> getOwnedList(
      List<TeamListViewModel> teamList) {
    return teamList == null
        ? List<TeamListViewModel>()
        : teamList.where((i) => i.isOwned == true).toList();
  }

  static Widget getTeamInfoAlert(
      BuildContext context, TeamDialogViewModel vm, TeamPageState state) {
    List<Widget> titleRowWidgets = <Widget>[
      Text(
        '${vm.displayName}',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    ];
    if (vm.isOwned) {
      titleRowWidgets.add(VerticalDivider(
        color: Colors.transparent,
      ));
      titleRowWidgets.add(Icon(
        Icons.verified_user,
        color: Colors.white,
      ));
    }
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
              Container(
                  padding: EdgeInsets.only(bottom: 15, left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: titleRowWidgets,
                  ))
            ],
          )),
    ];
    dialogWidgets.addAll(getStatusSection(vm, state, context));
    if (vm.agentList != null && vm.agentList.length > 0)
      dialogWidgets.addAll(getAgentsSection(vm.agentList));
    return DialogUtils.wrapInDialog(dialogWidgets);
  }

  static List<Widget> getStatusSection(
      TeamDialogViewModel vm, TeamPageState state, BuildContext context) {
    List<Widget> statusSectionWidgets = List<Widget>();
    statusSectionWidgets.add(Column(
      children: <Widget>[
        Card(
          color: WasabeeConstants.CARD_COLOR,
          child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Status: ${vm.statusString}',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )
                ],
              )),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: RaisedButton(
                  color: Colors.green,
                  child: Text(
                    '${vm.onOffString}',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    var data = Map<String, String>();
                    var onOffData = 'On';
                    if (vm.isEnabled) {
                      onOffData = 'Off';
                    }
                    data["state"] = onOffData;
                    Navigator.of(context).pop();
                    state.toggleTeam(vm.iD, data);
                  },
                ))
          ],
        )
      ],
    ));

    return statusSectionWidgets;
  }

  static List<Widget> getAgentsSection(List<Agent> agentList) {
    double imageSize = 25.0;
    List<Widget> agentSectionWidgets = List<Widget>();
    List<Widget> agentWidgets = List<Widget>();
    for (var agent in agentList) {
      agentWidgets.add(
        Column(children: <Widget>[
          Row(
            children: <Widget>[
              new Stack(children: <Widget>[
                new Center(
                    child: Container(
                  height: imageSize,
                  width: imageSize,
                  child: Icon(
                    Icons.account_circle,
                    color: WasabeeConstants.CARD_COLOR,
                  ),
                )),
                new Center(
                    child: Container(
                        height: imageSize,
                        width: imageSize,
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: agent.pic,
                        )))
              ]),
              VerticalDivider(),
              Text('${agent.name}')
            ],
          ),
          Divider(),
        ]),
      );
    }

    agentSectionWidgets.add(Container(
        margin: EdgeInsets.all(8),
        height: 150,
        child: SingleChildScrollView(
          child: Column(
            children: agentWidgets,
          ),
        )));
    return agentSectionWidgets;
  }
}
