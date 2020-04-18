import 'package:flutter/material.dart';
import 'package:wasabee/classutils/dialog.dart';
import 'package:wasabee/classutils/link.dart';
import 'package:wasabee/network/responses/operationFullResponse.dart';
import 'package:wasabee/pages/linkspage/linkfiltermanager.dart';
import 'package:wasabee/pages/linkspage/linklistvm.dart';
import 'package:wasabee/pages/linkspage/linksortdialog.dart';
import 'package:wasabee/pages/mappage/map.dart';
import 'package:wasabee/storage/localstorage.dart';

class LinksPage {
  static Widget getPageContent(List<LinkListViewModel> listOfVM,
      List<Link> listOfLinks, MapPageState mapPageState) {
        print('got links page');
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
                print("LIST VIEW MODEL -> ${vm.toString()}");
                return getListItem(vm, context, mapPageState, index);
              }))
    ]));
  }

  static Widget getListItem(LinkListViewModel vm, BuildContext context,
      MapPageState mapPageState, int index) {
    var orderColor = DialogUtils.getLinkListOrderBg(vm.linkOrder);
    var listBGColor = DialogUtils.getListBgColor(index);
    var margin = 8.0;
    return Container(
        color: listBGColor,
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
                          color: listBGColor,
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
                            Container(
                                padding: EdgeInsets.only(right: margin),
                                child: getLinkInfoLayout(vm, false)),
                            Flexible(
                              child: Container(
                                  padding: EdgeInsets.only(
                                    right: margin,
                                    bottom: margin,
                                  ),
                                  child: Text(
                                    vm.toPortalName,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  )),
                            )
                          ],
                        ))
                      ])),
                ]))));
  }

  static Widget getLinkInfoLayout(LinkListViewModel vm, bool useWhite) {
    var colorToUse = useWhite ? Colors.white : vm.portalReqColor;
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Icon(
          useWhite ? Icons.redo : Icons.arrow_downward,
          color: colorToUse,
        ),
        VerticalDivider(
          width: 5,
        ),
        Text(
          vm.lengthString,
          style: TextStyle(color: colorToUse),
        ),
        VerticalDivider(
          width: 5,
        ),
        Expanded(
            child: Divider(
          height: 4.0,
          color: colorToUse,
        )),
        VerticalDivider(
          width: 5,
        ),
        Text(
          'L${vm.portalReqLevel.toStringAsFixed(2)}',
          style: TextStyle(color: colorToUse),
        )
      ],
    );
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
