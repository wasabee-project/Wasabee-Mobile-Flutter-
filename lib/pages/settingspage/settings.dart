import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'package:wasabee/storage/localstorage.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.title, this.useImperial}) : super(key: key);

  final String title;
  final bool useImperial;

  @override
  _SettingsPageState createState() => _SettingsPageState(useImperial);
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<FormState> _unitsKey = GlobalKey<FormState>();
  bool useImperial = false;
  bool changedSettings = false;

  _SettingsPageState(bool useImperial) {
    this.useImperial = useImperial;
  }

  @override
  Widget build(BuildContext context) {
    String titleString = " - Settings";

    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, changedSettings);
          debugPrint("Will pop");
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title + titleString),
          ),
          body: CardSettings(shrinkWrap: true, children: <Widget>[
            CardSettingsHeader(label: 'Map Settings'),
            CardSettingsSwitch(
              showMaterialIOS: true,
              key: _unitsKey,
              label: 'Imperial Units',
              initialValue: useImperial,
              onSaved: (value) => useImperial = value,
              onChanged: (value) {
                LocalStorageUtils.setUseImperialUnits(value).then((any) {
                  changedSettings = true;
                  setState(() {
                    useImperial = value;
                  });
                });
              },
            )
          ]),
        ));
  }
}
