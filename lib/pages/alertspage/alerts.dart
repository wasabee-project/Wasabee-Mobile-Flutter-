import 'package:flutter/material.dart';
import 'package:wasabee/classutils/dialog.dart';
import 'package:wasabee/network/responses/operationFullResponse.dart';
import 'package:wasabee/pages/alertspage/alertfiltermanager.dart';
import 'package:wasabee/pages/alertspage/alertsortdialog.dart';
import 'package:wasabee/pages/alertspage/targetlistvm.dart';
import 'package:wasabee/pages/mappage/map.dart';
import 'package:wasabee/storage/localstorage.dart';

class AlertsPage {
  static Widget getPageContent(List<TargetListViewModel> listOfVM,
      List<Target> listOfTargets, MapPageState mapPageState) {
    return Scaffold(
        body: Column(children: <Widget>[
      Container(
          margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: .0),
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child: DropdownButton<AlertFilterType>(
                  isExpanded: true,
                  value: mapPageState.alertFilterDropdownValue,
                  underline: Divider(
                    color: Colors.white,
                  ),
                  onChanged: (AlertFilterType newValue) {
                    LocalStorageUtils.setAlertfilter(newValue).then((any) {
                      mapPageState.setAlerFilterDropdownValue(newValue);
                    });
                  },
                  items: AlertFilterManager.getFilters()
                      .map<DropdownMenuItem<AlertFilterType>>((value) {
                    return DropdownMenuItem<AlertFilterType>(
                      value: value,
                      child: Text(AlertFilterManager.getDisplayStringFromEnum(
                          value, listOfTargets, mapPageState.googleId)),
                    );
                  }).toList(),
                )),
                Row(
                  children: <Widget>[
                    Container(
                      width: 5.0,
                      height: 30.0,
                      color: Colors.green,
                    )
                  ],
                ),
                IconButton(
                  color: Colors.white,
                  icon: Icon(
                    Icons.sort,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    showDialog(
                        barrierDismissible: false,
                        context: mapPageState.context,
                        builder: (_) => AlertSortDialog(
                            selectedValue: mapPageState.alertSortDropdownValue,
                            baseState: mapPageState));
                  },
                ),
              ])),
      Divider(
        color: Colors.black,
        height: 4,
      ),
      Expanded(
          child: ListView.builder(
              itemCount: listOfVM.length,
              itemBuilder: (BuildContext context, int index) {
                TargetListViewModel vm = listOfVM[index];
                return Container(
                  padding: EdgeInsets.all(8),
                    color: DialogUtils.getListBgColor(index),
                    child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                            onTap: () {
                              mapPageState
                                  .makeZoomedPositionFromLatLng(vm.latLng);
                              mapPageState.tabController.animateTo(0);
                            },
                            child: Column(children: <Widget>[
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Image.asset(
                                      vm.imagePath,
                                      width: 50.0,
                                      height: 50.0,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    VerticalDivider(),
                                    Flexible(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          vm.titleString,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Divider(
                                          height: 8.0,
                                          color: Colors.green,
                                          endIndent: 15.0,
                                        ),
                                        Text(vm.stateString),
                                        Text(vm.distanceString),
                                      ],
                                    ))
                                  ]),
                            ]))));
              }))
    ]));
  }
}
