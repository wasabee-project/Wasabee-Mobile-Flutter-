import 'package:flutter/material.dart';
import 'package:wasabee/network/responses/operationFullResponse.dart';
import 'package:wasabee/pages/linkspage/linklistvm.dart';
import 'package:wasabee/pages/mappage/map.dart';

class LinksPage {
  static Widget getPageContent(List<LinkListViewModel> listOfVM,
      List<Link> listOfLinks, MapPageState mapPageState) {
    return Scaffold(
        body: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: listOfVM.length,
            itemBuilder: (BuildContext context, int index) {
              LinkListViewModel vm = listOfVM[index];
              return InkWell(
                  onTap: () {
                    print(
                        'vm titleString -> ${vm.fromPortalName} -> ${vm.toPortalName}');
                    //mapPageState.makeZoomedPositionFromLatLng(vm.latLng);
                    //mapPageState.tabController.animateTo(0);
                  },
                  child: Column(children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                              child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                child: Text('${vm.linkOrder}'),
                              ),
                              VerticalDivider(
                                width: 15,
                              ),
                              Text(
                                vm.fromPortalName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              VerticalDivider(
                                width: 5,
                              ),
                              Icon(Icons.arrow_right),
                              VerticalDivider(width: 5),
                              Flexible(
                                  child: Text(
                                vm.toPortalName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ))
                            ],
                          )),
                        ]),
                    Divider(
                      height: 10.0,
                      color: Colors.grey,
                    )
                  ]));
            }));
  }
}
