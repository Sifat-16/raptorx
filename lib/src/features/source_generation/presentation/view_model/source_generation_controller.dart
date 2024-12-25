import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/features/source_generation/presentation/view_model/mixins/create_directory_structure_mixin.dart';
import 'package:raptorx/src/features/source_generation/presentation/view_model/source_generation_generic.dart';
import 'package:raptorx/src/features/source_mould/data/t_rex_constant_model.dart';
import 'package:raptorx/src/features/source_mould/data/t_rex_model.dart';

final sourceGenerationProvider =
    StateNotifierProvider<SourceGenerationController, SourceGenerationGeneric>(
        (ref) => SourceGenerationController());

class SourceGenerationController extends StateNotifier<SourceGenerationGeneric>
    with CreateDirectoryStructureMixin {
  SourceGenerationController() : super(SourceGenerationGeneric());

  void createSourceCode() async {
    if (state.selectedLocationToGenerate != null) {
      TRexModel? tRexModel = state.tRexModel;
      String? trexStoragePath = state.trexStoragePath;
      TRexConstantModel? tRexConstantModel = state.tRexConstantModel;

      if (tRexModel != null &&
          trexStoragePath != null &&
          tRexConstantModel != null) {
        createDirectoryStructure(state.selectedLocationToGenerate!,
            trexStoragePath, tRexModel, tRexConstantModel);
      }
    }
  }

  void updateDirectory({required String directory}) async {
    final dir = Directory(directory);

    if (await dir.exists()) {
      // List the contents of the directory
      final List<FileSystemEntity> entities = dir.listSync();

      // Check for the existence of a folder named 'TrexStorage'
      final hasTrexStorageFolder = entities.any((entity) =>
          entity is Directory &&
          entity.path.split(Platform.pathSeparator).last == 'TrexStorage');

      // Check for the existence of at least one .trex file
      final hasTrexFile = entities
          .any((entity) => entity is File && entity.path.endsWith('.trex'));

      final hasTrexConstantFile = entities.any(
          (entity) => entity is File && entity.path.endsWith('.tconstant'));

      if (hasTrexStorageFolder && hasTrexFile && hasTrexConstantFile) {
        // Both conditions are satisfied, proceed to update the directory

        String trexStoragePath = entities
            .where((entity) =>
                entity is Directory &&
                entity.path.split(Platform.pathSeparator).last == 'TrexStorage')
            .first
            .path;

        String filePath = entities
            .where((entity) => entity.path.endsWith(".trex"))
            .first
            .path;

        String constantFilePath = entities
            .where((entity) => entity.path.endsWith(".tconstant"))
            .first
            .path;
        String jsonContent = await File(filePath).readAsString();

        // Decode the JSON and create a TRexModel instance
        Map<String, dynamic> jsonData = jsonDecode(jsonContent);
        TRexModel tRexModel = TRexModel.fromJson(jsonData);

        String constantjsonContent =
            await File(constantFilePath).readAsString();

        // Decode the JSON and create a TRexModel instance
        Map<String, dynamic> constantjsonData = jsonDecode(constantjsonContent);
        TRexConstantModel tRexConstantModel =
            TRexConstantModel.fromJson(constantjsonData);

        state = state.update(
            selectedLocationToGenerate: directory,
            tRexModel: tRexModel,
            tRexConstantModel: tRexConstantModel,
            trexStoragePath: trexStoragePath);
      } else {
        // Conditions not met, do not save the directory
        BotToast.showText(
            text:
                "The directory does not contain TrexStorage and/or .trex and/or .tconstant file.");
      }
    } else {
      BotToast.showText(text: "Directory does not exist.");
    }
  }
}
