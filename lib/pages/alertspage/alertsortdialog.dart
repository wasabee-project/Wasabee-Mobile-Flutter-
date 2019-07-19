import 'package:flutter/material.dart';
import 'package:wasabee/pages/alertspage/alertsortmanager.dart';
import 'package:wasabee/pages/mappage/map.dart';
import 'package:wasabee/storage/localstorage.dart';

class AlertSortDialog extends StatefulWidget {
  AlertSortDialog({Key key, this.selectedValue, this.baseState})
      : super(key: key);

  final AlertSortType selectedValue;
  final MapPageState baseState;

  @override
  AlertSortDialogState createState() =>
      new AlertSortDialogState(selectedValue, baseState);
}

class AlertSortDialogState extends State<AlertSortDialog> {
  AlertSortType selectedValue;
  MapPageState baseState;

  AlertSortDialogState(AlertSortType selectedValue, MapPageState baseState) {
    this.selectedValue = selectedValue;
    this.baseState = baseState;
  }

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
        title: new Text("Alert Sorting"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Container(
                child: new DropdownButton(
              value: selectedValue,
              isExpanded: true,
              onChanged: (AlertSortType value) {
                LocalStorageUtils.setAlertSort(value).then((any) {
                  baseState.setAlertSortDropdownValue(value);
                  Navigator.of(context).pop();
                });
                setState(() {
                  selectedValue = value;
                });
              },
              items: AlertSortManager.getFilters().map((AlertSortType value) {
                return new DropdownMenuItem<AlertSortType>(
                  value: value,
                  child: new Text(
                      AlertSortManager.getDisplayStringFromEnum(value)),
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

enum AlertSortType {
  TargetType, //alpha by type
  CurrentState, //alpha by state after alpha by type
  AlphaName, //just alpha by name of portal
  Distance //NO ALPHA, JUST DISTANCE
}
