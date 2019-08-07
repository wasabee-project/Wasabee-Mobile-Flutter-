import 'package:flutter/material.dart';
import 'package:wasabee/pages/teamspage/team.dart';
import 'package:wasabee/pages/teamspage/teamsortmanager.dart';
import 'package:wasabee/storage/localstorage.dart';

class TeamSortDialog extends StatefulWidget {
  TeamSortDialog({Key key, this.selectedValue, this.baseState})
      : super(key: key);

  final TeamSortType selectedValue;
  final TeamPageState baseState;

  @override
  TeamSortDialogState createState() =>
      new TeamSortDialogState(selectedValue, baseState);
}

class TeamSortDialogState extends State<TeamSortDialog> {
  TeamSortType selectedValue;
  TeamPageState baseState;

  TeamSortDialogState(TeamSortType selectedValue, TeamPageState baseState) {
    this.selectedValue = selectedValue;
    this.baseState = baseState;
  }

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
        title: new Text("Team Sorting"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Container(
                child: new DropdownButton(
              value: selectedValue,
              isExpanded: true,
              onChanged: (TeamSortType value) {
                LocalStorageUtils.setTeamSort(value).then((any) {
                  baseState.setTeamSortDropdownValue(value);
                  Navigator.of(context).pop();
                });
                setState(() {
                  selectedValue = value;
                });
              },
              items: TeamSortManager.getFilters().map((TeamSortType value) {
                return new DropdownMenuItem<TeamSortType>(
                  value: value,
                  child: new Text(
                      TeamSortManager.getDisplayStringFromEnum(value)),
                );
              }).toList(),
            )),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ]);
  }
}

enum TeamSortType {
  AlphaName, //alphabetical name
  CurrentState, //off or on
  Owned, //if user owns the team
}