import 'package:flutter/material.dart';
import 'package:wasabee/classutils/target.dart';
import 'package:wasabee/network/responses/operationFullResponse.dart';
import 'package:wasabee/pages/mappage/markerutilities.dart';

class AlertsPage {
  static Widget getPageContent(
      List<Target> targets, Map<String, Portal> portalMap, String googleId) {
    return Scaffold(
        body: Column(children: <Widget>[
      Text('Filter Layout will go here'),
      Expanded(
          child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: targets.length,
              itemBuilder: (BuildContext context, int index) {
                Target target = targets[index];
                Portal portal = portalMap[target.portalId];
                return Column(children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          "assets/dialog_icons/${MarkerUtilities.getImagePath(target, googleId, MarkerUtilities.SEGMENT_ICON)}",
                          width: 50.0,
                          height: 50.0,
                          fit: BoxFit.fitHeight,
                        ),
                        VerticalDivider(),
                        Flexible(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                '${TargetUtils.getMarkerTitle(portal.name, target)}',
                                overflow: TextOverflow.ellipsis),
                            Divider( 
                              height: 8.0,
                              color: Colors.green,
                              endIndent: 15.0,
                            ),
                            Text(
                                '${TargetUtils.getDisplayState(target, googleId)}')
                          ],
                        ))
                      ]),
                  Divider(
                    height: 10.0,
                    color: Colors.grey,
                  )
                ]);
              }))
    ]));
  }
}
