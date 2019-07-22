import 'package:flutter/material.dart';
import 'package:wasabee/network/responses/operationFullResponse.dart';
import 'package:wasabee/pages/linkspage/linklistvm.dart';
import 'package:wasabee/pages/mappage/map.dart';

class LinksPage {
  static Widget getPageContent(List<LinkListViewModel> listOfVM,
      List<Link> listOfLinks, MapPageState mapPageState) {
    return Scaffold(
        body: Column(children: <Widget>[
      Expanded(
          child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: listOfVM.length,
              itemBuilder: (BuildContext context, int index) {
                LinkListViewModel vm = listOfVM[index];
                return InkWell(
                    onTap: () {
                      print('vm titleString -> ${vm.titleString}');
                      //mapPageState.makeZoomedPositionFromLatLng(vm.latLng);
                      //mapPageState.tabController.animateTo(0);
                    },
                    child: Column(children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  vm.titleString,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
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
