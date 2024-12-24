import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/config/database/dao/build_config_dao.dart';
import 'package:raptorx/src/core/build_config/build_generic.dart';
import 'package:raptorx/src/core/dependency_injection/dependency_injection.dart';
import 'package:raptorx/src/features/settings/data/model/build_config_model.dart';

final buildConfigProvider =
    StateNotifierProvider<BuildController, BuildGeneric>(
        (ref) => BuildController(ref));

class BuildController extends StateNotifier<BuildGeneric> {
  BuildController(this.ref) : super(BuildGeneric());
  Ref ref;

  BuildConfigDao buildConfigDao = sl.get();

  Future<String?> updateSourceCodeDirectory({String? sourceCode}) async {
    String? result;
    if (sourceCode != null) {
      BuildConfigModel? buildConfigModel =
          await buildConfigDao.addBuildConfigData(
              BuildConfigModel(sourceCodeDirectory: sourceCode));

      result = buildConfigModel?.sourceCodeDirectory;

      if (buildConfigModel != null) {
        state = state.update(buildConfigModel: buildConfigModel);
      }
    }

    return result;
  }

  fetchSourceCodeDirectory() async {
    BuildConfigModel? buildConfigModel =
        await buildConfigDao.readBuildConfigData();

    state = state.update(buildConfigModel: buildConfigModel);
  }
}
