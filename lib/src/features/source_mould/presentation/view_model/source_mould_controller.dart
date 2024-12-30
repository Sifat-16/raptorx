import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/core/extractor/file/file_extractor.dart';
import 'package:raptorx/src/features/brand_v2/brands/data/model/brand_model.dart';
import 'package:raptorx/src/features/brand_v2/brands/presentation/view_model/brands_v2_controller.dart';
import 'package:raptorx/src/features/source_generation/presentation/view_model/mixins/create_directory_structure_mixin.dart';
import 'package:raptorx/src/features/source_mould/data/t_rex_constant_model.dart';
import 'package:raptorx/src/features/source_mould/data/t_rex_model.dart';
import 'package:raptorx/src/features/source_mould/presentation/view_model/mixins/directory_operation_mixin.dart';
import 'package:raptorx/src/features/source_mould/presentation/view_model/source_mould_generic.dart';

final sourceMouldProvider = StateNotifierProvider.autoDispose<
    SourceMouldController,
    SourceMouldGeneric>((ref) => SourceMouldController(ref));

class SourceMouldController extends StateNotifier<SourceMouldGeneric>
    with CreateDirectoryStructureMixin, DirectoryOperationMixin {
  SourceMouldController(this.ref) : super(SourceMouldGeneric());

  Ref ref;

  void updateDirectory({required String directory}) {
    state = state.update(selectedDirectory: directory);
  }

  void updateTRexStorageDirectory({required String directory}) {
    state = state.update(selectedTRexStorageDirectory: directory);
  }

  void updateTRexModel({required TRexModel tRexModel}) {
    state = state.update(tRexModel: tRexModel);
  }

  void updateTRexConstantModel({required TRexConstantModel tRexConstantModel}) {
    state = state.update(tRexConstantModel: tRexConstantModel);
  }

  createNewTRexInsideParent(
      {required TRexModel tRexModel, required String parent}) {
    TRexModel? root = state.tRexModel;
    if (root != null) {
      if (root.checkDuplicate(parentId: parent, child: tRexModel, root: root)) {
        BotToast.showText(text: "Resource Already Exists");
        return;
      } else {
        state = state.update(
            tRexModel: root.createNewTRexInsideParent(
                newModel: tRexModel, parentId: parent));
      }
    }
  }

  void deleteResources({required String id}) {
    state = state.update(
        tRexModel: state.tRexModel?.deleteResource(resourceId: id));
  }

  void updateNewTRexInsideParent(
      {required TRexModel tRexModel, required String parent}) {
    TRexModel? root = state.tRexModel;
    if (root != null) {
      if (root.checkDuplicate(parentId: parent, child: tRexModel, root: root)) {
        BotToast.showText(text: "Resource Already Exists");
        return;
      } else {
        state = state.update(
            tRexModel: state.tRexModel?.updateChildTRexModel(
                parentModel: state.tRexModel!, updatedModel: tRexModel));
      }
    }
  }

  Future<void> exportTRexModelWithCustomExtension() async {
    try {
      TRexModel tRexModel = state.tRexModel!;
      // Convert TRexModel to JSON
      String jsonContent = jsonEncode(tRexModel.toJson());

      // Prompt the user to pick a location to save the file
      String? savePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save your TRexModel file',
        fileName: 'trexmodel.trex', // Default file name with .trex extension
        type: FileType.custom,
        allowedExtensions: ['trex'], // Custom extension
      );

      if (savePath == null) {
        print('Save operation was canceled.');
        return;
      }

      // Ensure the file has the .trex extension
      if (!savePath.endsWith('.trex')) {
        savePath += '.trex';
      }

      // Write the JSON content to the selected file
      File file = File(savePath);
      await file.writeAsString(jsonContent);
      print('TRexModel exported successfully to $savePath');
    } catch (e) {
      print('Error exporting TRexModel: $e');
    }
  }

  Future<TRexModel?> importTRexModelWithCustomExtension() async {
    try {
      // Prompt the user to pick a file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Select a TRexModel file',
        type: FileType.custom,
        allowedExtensions: ['trex'], // Restrict to .trex files
      );

      if (result == null || result.files.single.path == null) {
        print('Import operation was canceled.');
        return null;
      }

      String filePath = result.files.single.path!;

      // Validate the file extension
      if (!filePath.endsWith('.trex')) {
        print('Invalid file format. Please select a .trex file.');
        return null;
      }

      TRexModel tRexModel = await FileExtractor.extractDataFromFile(
          file: File(filePath), extractor: (json) => TRexModel.fromJson(json));
      state = state.update(tRexModel: tRexModel);

      print('TRexModel imported successfully from $filePath');
      return tRexModel;
    } catch (e) {
      print('Error importing TRexModel: $e');
      return null;
    }
  }

  void deleteTRexConstants() {
    state = state.update(eraseConstantModel: true);
  }

  void importTRexConstant({required BuildContext context}) async {
    try {
      // Prompt the user to pick a file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Select a TRex Constant file',
        type: FileType.custom,
        allowedExtensions: ['tconstant'], // Restrict to .trex files
      );

      if (result == null || result.files.single.path == null) {
        print('Import operation was canceled.');
        return null;
      }

      String filePath = result.files.single.path!;

      // Validate the file extension
      if (!filePath.endsWith('.tconstant')) {
        print('Invalid file format. Please select a .trex file.');
        return null;
      }

      TRexConstantModel tRexConstantModel =
          await FileExtractor.extractDataFromFile(
              file: File(filePath),
              extractor: (json) => TRexConstantModel.fromJson(json));

      state = state.update(tRexConstantModel: tRexConstantModel);

      print('TRex Constant imported successfully from $filePath');
    } catch (e) {
      print('Error importing TRex Constant: $e');
      return null;
    }
  }

  void exportTRexConstant({required BuildContext context}) async {
    try {
      TRexConstantModel tRexModel = state.tRexConstantModel!;
      // Convert TRexModel to JSON
      String jsonContent = jsonEncode(tRexModel.toJson());

      // Prompt the user to pick a location to save the file
      String? savePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save your TRex Constant file',
        fileName:
            'trexconstant.tconstant', // Default file name with .trex extension
        type: FileType.custom,
        allowedExtensions: ['tconstant'], // Custom extension
      );

      if (savePath == null) {
        print('Save operation was canceled.');
        return;
      }

      // Ensure the file has the .trex extension
      if (!savePath.endsWith('.tconstant')) {
        savePath += '.tconstant';
      }

      // Write the JSON content to the selected file
      File file = File(savePath);
      await file.writeAsString(jsonContent);
      print('TRex Constant exported successfully to $savePath');
    } catch (e) {
      print('Error exporting TRexModel: $e');
    }
  }

  void deleteTRexConstantSource({required String key}) {
    TRexConstantModel? tRexConstantModel = state.tRexConstantModel;
    if (tRexConstantModel != null) {
      tRexConstantModel.data.remove(key);
      state = state.update(tRexConstantModel: tRexConstantModel);
    }
  }

  List<String> checkValidConstant({required String content}) {
    TRexConstantModel? tRexConstantModel = state.tRexConstantModel;
    if (tRexConstantModel == null) {
      BotToast.showText(text: "Add Valid Constant File First");
      return ["No Valid Constant File"];
    } else {
      // Regular expression to match <<rptr constant: some_value /rptr>>
      final regex = RegExp(r'<<rptr constant:\s*(\w+)\s*/rptr>>');
      final matches = regex.allMatches(content);

      List<String> invalidConstants = [];
      for (final match in matches) {
        // Extract the constant value
        String constantKey = match.group(1) ?? '';

        // Check if the constant exists in any of the TRexConstantModel instances
        bool isValid = tRexConstantModel.data.containsKey(constantKey);

        if (!isValid) {
          invalidConstants.add(constantKey);
        }
      }
      return invalidConstants;
    }
  }

  void initiateMould({required BrandModel brandModel}) async {
    try {
      Directory brandDirectory = Directory(
          "${ref.read(brandsV2Provider).sourceLocation}${brandModel.brandLocation}");
      List<FileSystemEntity> files = brandDirectory.listSync();

      File trex = File(files.firstWhere((entity) {
        return (entity is File && entity.path.contains(".trex"));
      }).path);

      TRexModel tRexModel = await FileExtractor.extractDataFromFile(
          file: trex, extractor: (json) => TRexModel.fromJson(json));

      File trexConstant = File(files.firstWhere((entity) {
        return (entity is File && entity.path.contains(".tconstant"));
      }).path);

      TRexConstantModel tRexConstantModel =
          await FileExtractor.extractDataFromFile(
              file: trexConstant,
              extractor: (json) => TRexConstantModel.fromJson(json));

      String? selectedTrexStorage =
          Directory("${brandDirectory.path}/TrexStorage").existsSync()
              ? "${brandDirectory.path}/TrexStorage"
              : null;
      state = state.update(
          tRexModel: tRexModel,
          tRexConstantModel: tRexConstantModel,
          selectedTRexStorageDirectory: selectedTrexStorage);
    } catch (e) {
      print("Error while fetching files ${e.toString()}");
    }
  }
}
