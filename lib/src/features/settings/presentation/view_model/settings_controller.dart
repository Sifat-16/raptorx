import 'package:bot_toast/bot_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/config/database/dao/build_config_dao.dart';
import 'package:raptorx/src/core/build_config/build_controller.dart';
import 'package:raptorx/src/core/dependency_injection/dependency_injection.dart';
import 'package:raptorx/src/features/settings/data/model/build_config_model.dart';
import 'package:raptorx/src/features/settings/presentation/view_model/settings_generic.dart';


final settingsProvider = StateNotifierProvider<SettingsController, SettingsGeneric>((ref)=>SettingsController(ref));

class SettingsController extends StateNotifier<SettingsGeneric>{
  SettingsController(this.ref):super(SettingsGeneric());
  Ref ref;

  onSelectSourceCode()async{
    String? directoryPath = await FilePicker.platform.getDirectoryPath();
    if (directoryPath != null) {
      String? sourceCode = await ref.read(buildConfigProvider.notifier).updateSourceCodeDirectory(sourceCode: directoryPath);
      if(sourceCode!=null){
        state = state.update(sourceCodeDirectory: sourceCode);
        BotToast.showText(text: "Successfully selected source code");
      }else{
        BotToast.showText(text: "Couldn't select source code");
      }
    }
  }





}