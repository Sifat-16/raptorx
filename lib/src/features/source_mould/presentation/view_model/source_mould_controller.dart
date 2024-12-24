import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/features/source_generation/presentation/view_model/mixins/create_directory_structure_mixin.dart';
import 'package:raptorx/src/features/source_mould/data/t_rex_model.dart';
import 'package:raptorx/src/features/source_mould/presentation/view_model/mixins/directory_operation_mixin.dart';
import 'package:raptorx/src/features/source_mould/presentation/view_model/source_mould_generic.dart';

final sourceMouldProvider =
    StateNotifierProvider<SourceMouldController, SourceMouldGeneric>(
        (ref) => SourceMouldController());

class SourceMouldController extends StateNotifier<SourceMouldGeneric>
    with CreateDirectoryStructureMixin, DirectoryOperationMixin {
  SourceMouldController() : super(SourceMouldGeneric());

  void updateDirectory({required String directory}) {
    state = state.update(selectedDirectory: directory);
  }

  void updateTRexStorageDirectory({required String directory}) {
    state = state.update(selectedTRexStorageDirectory: directory);
  }

  void updateTRexModel({required TRexModel tRexModel}) {
    state = state.update(tRexModel: tRexModel);
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

      // Read the JSON file
      String jsonContent = await File(filePath).readAsString();

      // Decode the JSON and create a TRexModel instance
      Map<String, dynamic> jsonData = jsonDecode(jsonContent);
      TRexModel tRexModel = TRexModel.fromJson(jsonData);

      state = state.update(tRexModel: tRexModel);

      print('TRexModel imported successfully from $filePath');
      return tRexModel;
    } catch (e) {
      print('Error importing TRexModel: $e');
      return null;
    }
  }
}
