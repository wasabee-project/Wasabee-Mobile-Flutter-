import 'package:flutter/material.dart';
import 'package:wasabee/pages/linkspage/linksortmanager.dart';
import 'package:wasabee/pages/mappage/map.dart';
import 'package:wasabee/storage/localstorage.dart';

class LinkSortDialog extends StatefulWidget {
  LinkSortDialog({Key key, this.selectedValue, this.baseState})
      : super(key: key);

  final LinkSortType selectedValue;
  final MapPageState baseState;

  @override
  LinkSortDialogState createState() =>
      new LinkSortDialogState(selectedValue, baseState);
}

class LinkSortDialogState extends State<LinkSortDialog> {
  LinkSortType selectedValue;
  MapPageState baseState;

  LinkSortDialogState(LinkSortType selectedValue, MapPageState baseState) {
    this.selectedValue = selectedValue;
    this.baseState = baseState;
  }

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
        title: new Text("Link Sorting"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Container(
                child: new DropdownButton(
              value: selectedValue,
              isExpanded: true,
              onChanged: (LinkSortType value) {
                LocalStorageUtils.setLinkSort(value).then((any) {
                  baseState.setLinkSortDropdownValue(value);
                  Navigator.of(context).pop();
                });
                setState(() {
                  selectedValue = value;
                });
              },
              items: LinkSortManager.getFilters().map((LinkSortType value) {
                return new DropdownMenuItem<LinkSortType>(
                  value: value,
                  child: new Text(
                      LinkSortManager.getDisplayStringFromEnum(value)),
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

enum LinkSortType {
  LinkLength, //distance of link
  AlphaFromPortal, //just alpha by name of from portal
  AlphaToPortal, //just alpha by name of to portal
  LinkOrder, //order to link in
}
