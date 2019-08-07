import 'package:flutter/material.dart';
import 'package:wasabee/classutils/dialog.dart';
import 'package:wasabee/classutils/link.dart';
import 'package:wasabee/network/responses/operationFullResponse.dart';
import 'package:wasabee/pages/linkspage/linkfiltermanager.dart';
import 'package:wasabee/pages/linkspage/linklistvm.dart';
import 'package:wasabee/pages/linkspage/linksortdialog.dart';
import 'package:wasabee/pages/mappage/map.dart';
import 'package:wasabee/pages/mappage/utilities.dart';
import 'package:wasabee/storage/localstorage.dart';

class LinksPage {
  static Widget getPageContent(List<LinkListViewModel> listOfVM,
      List<Link> listOfLinks, MapPageState mapPageState) {
    return Scaffold(
        body: Column(children: <Widget>[
      Container(
          margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: .0),
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                VerticalDivider(),
                Expanded(
                    child: DropdownButton<LinkFilterType>(
                  isExpanded: true,
                  value: mapPageState.linkFilterDropdownValue,
                  underline: Divider(
                    color: Colors.white,
                  ),
                  onChanged: (LinkFilterType newValue) {
                    LocalStorageUtils.setLinkFilter(newValue).then((any) {
                      mapPageState.setLinkFilterDropdownValue(newValue);
                    });
                  },
                  items: LinkFilterManager.getFilters()
                      .map<DropdownMenuItem<LinkFilterType>>((value) {
                    return DropdownMenuItem<LinkFilterType>(
                      value: value,
                      child: Text(LinkFilterManager.getDisplayStringFromEnum(
                          value, listOfLinks, mapPageState.googleId)),
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
                        builder: (_) => LinkSortDialog(
                            selectedValue: mapPageState.linkSortDropDownValue,
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
                LinkListViewModel vm = listOfVM[index];
                return getListItem(vm, context, mapPageState, index);
              }))
    ]));
  }

  static Widget getListItem(LinkListViewModel vm, BuildContext context,
      MapPageState mapPageState, int index) {
    var orderColor = DialogUtils.getLinkListOrderBg(vm.linkOrder);
    var margin = 8.0;
    return Container(
        color: DialogUtils.getListBgColor(index),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                splashColor: orderColor,
                onTap: () {
                  onLinkRowTap(vm, mapPageState);
                },
                child: Column(children: <Widget>[
                  IntrinsicHeight(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                        Container(
                          width: 45,
                          color: orderColor,
                          child: vm.completed == true
                              ? Center(child: Icon(Icons.check))
                              : Center(
                                  child: Text('${vm.linkOrder}',
                                      style: TextStyle(color: Colors.white))),
                        ),
                        VerticalDivider(
                          width: 15,
                        ),
                        Flexible(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                padding:
                                    EdgeInsets.only(top: margin, right: margin),
                                child: Text(
                                  vm.fromPortalName,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                )),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(Icons.arrow_right),
                                VerticalDivider(width: 5),
                                Flexible(
                                  child: Container(
                                      padding: EdgeInsets.only(right: margin),
                                      child: Text(
                                        vm.toPortalName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                ),
                              ],
                            ),
                            Container(
                                padding: EdgeInsets.only(
                                    bottom: margin, right: margin),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Icon(
                                      Icons.redo,
                                      color: Colors.black,
                                    ),
                                    VerticalDivider(
                                      width: 5,
                                    ),
                                    Text(vm.lengthString),
                                    VerticalDivider(
                                      width: 5,
                                    ),
                                    Expanded(
                                        child: Divider(
                                      height: 4.0,
                                      color: Colors.green,
                                    )),
                                    VerticalDivider(width: 5,),
                                    Text('L${MapUtilities.getPortalLevel(vm.lengthMeters).toStringAsFixed(2)}')
                                  ],
                                ))
                          ],
                        ))
                      ])),
                ]))));
  }

  static onLinkRowTap(LinkListViewModel vm, MapPageState state) {
    LocalStorageUtils.getGoogleId().then((googleId) {
      showDialog<void>(
        context: state.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LinkUtils.getLinkInfoAlert(context, vm, googleId,
              state.loadedOperation, state, MediaQuery.of(context).size.width);
        },
      );
    });
  }
}
