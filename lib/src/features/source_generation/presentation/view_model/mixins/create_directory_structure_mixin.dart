import 'dart:io';

import 'package:raptorx/src/core/enum/DirectoryInstanceType.dart';
import 'package:raptorx/src/features/source_mould/data/t_rex_model.dart';

mixin CreateDirectoryStructureMixin {
  void createDirectoryStructure(
      String rootPath, String trexStoragePath, TRexModel model) async {
    // First, create the base directory for the root model
    if (model.directoryInstanceType == DirectoryInstanceType.FOLDER) {
      final directory = Directory('$rootPath/${model.name}');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
        print('Created directory: $directory');
      }
    }

    // If it's a file, create the file and write content to it
    if (model.directoryInstanceType == DirectoryInstanceType.FILE) {
      final file = File('$rootPath/${model.name}');
      if (model.content != null) {
        await file.writeAsString(model.content!);
        print('Created file: $file with content');
      }
    }

    // Handle MEDIAFILE type
    if (model.directoryInstanceType == DirectoryInstanceType.MEDIAFILE) {
      if (model.copyLocation != null) {
        String finalLocation = trexStoragePath + model.copyLocation!;
        final sourceFile = File(finalLocation);
        final destinationFile = File('$rootPath/${model.name}');
        if (await sourceFile.exists()) {
          await sourceFile.copy(destinationFile.path);
          print(
              'Copied MEDIAFILE: ${sourceFile.path} to ${destinationFile.path}');
        } else {
          print('Source file does not exist: ${sourceFile.path}');
        }
      } else {
        print('No copy location provided for MEDIAFILE: ${model.name}');
      }
    }

    // If it's a folder, recursively call createDirectoryStructure for its children
    if (model.directoryInstanceType == DirectoryInstanceType.FOLDER &&
        model.tRexModel != null) {
      for (var child in model.tRexModel!) {
        createDirectoryStructure('$rootPath/${model.name}', trexStoragePath,
            child); // Recursive call
      }
    }
  }
}
