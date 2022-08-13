import 'package:revanced_manager/app/app.locator.dart';
import 'package:revanced_manager/models/application_info.dart';
import 'package:revanced_manager/models/patch.dart';
import 'package:revanced_manager/services/patcher_api.dart';
import 'package:revanced_manager/ui/views/app_selector/app_selector_viewmodel.dart';
import 'package:revanced_manager/ui/views/patcher/patcher_viewmodel.dart';
import 'package:revanced_manager/ui/widgets/patch_item.dart';
import 'package:stacked/stacked.dart';

class PatchesSelectorViewModel extends BaseViewModel {
  final PatcherAPI patcherAPI = locator<PatcherAPI>();
  List<Patch>? patches = [];
  List<Patch> selectedPatches = [];

  Future<void> initialize() async {
    await getPatches();
    notifyListeners();
  }

  Future<void> getPatches() async {
    ApplicationInfo? app = locator<AppSelectorViewModel>().selectedApp;
    patches = await patcherAPI.getFilteredPatches(app);
  }

  void selectPatches(List<PatchItem> patchItems) {
    selectedPatches.clear();
    if (patches != null) {
      for (PatchItem patch in patchItems) {
        if (patch.isSelected) {
          selectedPatches.add(
            patches!.firstWhere((element) => element.name == patch.name),
          );
        }
      }
    }
    locator<PatcherViewModel>().showFabButton =
        selectedPatches.isNotEmpty ? true : false;
    locator<PatcherViewModel>().notifyListeners();
  }
}
