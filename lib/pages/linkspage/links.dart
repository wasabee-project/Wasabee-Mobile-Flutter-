import 'package:flutter/material.dart';
import 'package:wasabee/network/responses/operationFullResponse.dart';
import 'package:wasabee/pages/linkspage/linkfiltermanager.dart';
import 'package:wasabee/pages/linkspage/linklistvm.dart';
import 'package:wasabee/pages/linkspage/linksortdialog.dart';
import 'package:wasabee/pages/mappage/map.dart';
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
              padding: const EdgeInsets.all(8.0),
              itemCount: listOfVM.length,
              itemBuilder: (BuildContext context, int index) {
                LinkListViewModel vm = listOfVM[index];
                return InkWell(
                    onTap: () {
                      //mapPageState.makeZoomedPositionFromLatLng(vm.latLng);
                      //mapPageState.tabController.animateTo(0);
                    },
                    child: Column(children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            CircleAvatar(
                              child: vm.completed == true
                                  ? Icon(Icons.check)
                                  : Text('${vm.linkOrder}'),
                            ),
                            VerticalDivider(
                              width: 15,
                            ),
                            Flexible(
                                child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      vm.fromPortalName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    VerticalDivider(
                                      width: 5,
                                    ),
                                    Icon(Icons.arrow_right),
                                    VerticalDivider(width: 5),
                                    Flexible(
                                      child: Text(
                                        vm.toPortalName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  height: 4.0,
                                  color: Colors.green,
                                ),
                                Text(vm.lengthString),
                              ],
                            ))
                          ]),
                      Divider(
                        height: 10.0,
                        color: Colors.grey,
                      )
                    ]));
              }))
    ]));
  }
}
