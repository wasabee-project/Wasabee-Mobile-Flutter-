import 'package:wasabee/network/responses/teamResponse.dart';
import 'package:wasabee/pages/teamspage/teamlistvm.dart';

class TeamDialogViewModel {
  String displayName;
  String statusString;
  String onOffString;
  bool isEnabled;
  bool isOwned;
  String iD;
  List<Agent> agentList;

  TeamDialogViewModel(
      {this.displayName,
      this.statusString,
      this.onOffString,
      this.isEnabled,
      this.isOwned,
      this.iD,
      this.agentList});

  static TeamDialogViewModel fromObjects(
      TeamListViewModel listVm, TeamResponse response) {
    List<Agent> agentList;
    String statusString = 'Disabled';
    String onOffString = 'Enable Team';
    if (listVm.isEnabled) {
      statusString = 'Enabled';
      onOffString = 'Disable Team';
    }
    if (response != null) agentList = response.agents;
    return TeamDialogViewModel(
        displayName: listVm.teamName,
        statusString: statusString,
        onOffString: onOffString,
        isEnabled: listVm.isEnabled,
        isOwned: listVm.isOwned,
        iD: listVm.teamId,
        agentList: agentList);
  }
}
