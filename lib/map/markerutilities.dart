import 'package:wasabee/classutils/target.dart';
import 'package:wasabee/network/responses/operationFullResponse.dart';

class MarkerUtilities {
  static const SEGMENT_MARKER = "wasabee_markers_";
  static const SEGMENT_FILE_EXT = ".bmp";

  static String getIconPath(Target target) {
    var typePathSegment = "other_";
    switch (target.type) {
      case TargetUtils.LetDecayPortalAlert:
        typePathSegment = "decay_";
        break;
      case TargetUtils.DestroyPortalAlert:
        typePathSegment = "destroy_";
        break;
      case TargetUtils.UseVirusPortalAlert:
        typePathSegment = "virus_";
        break;
    }
    var statusPathSegment = getTargetStatusSegment(target);
    return "$SEGMENT_MARKER$typePathSegment$statusPathSegment$SEGMENT_FILE_EXT";
  }

  static String getTargetStatusSegment(Target target) {
    var targetStatus = "pending";
    //TODO compare assignedTo to the saved googleID to check if assigned to that person
    //If not, and is not blank is assigned
    //if got here, check complete

    return targetStatus;
  }
}
