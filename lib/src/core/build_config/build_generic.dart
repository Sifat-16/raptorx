import 'package:raptorx/src/features/settings/data/model/build_config_model.dart';

class BuildGeneric{
  BuildConfigModel? buildConfigModel;
  BuildGeneric({this.buildConfigModel});

  BuildGeneric update({
    BuildConfigModel? buildConfigModel
}){
    return BuildGeneric(buildConfigModel: buildConfigModel??this.buildConfigModel);
  }


}