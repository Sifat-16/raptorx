import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:raptorx/src/core/enum/DirectoryInstanceType.dart';
import 'package:raptorx/src/features/source_mould/data/t_rex_constant_model.dart';
import 'package:raptorx/src/features/source_mould/data/t_rex_model.dart';

mixin CreateDirectoryStructureMixin {
  void createDirectoryStructure(String rootPath, String trexStoragePath,
      TRexModel model, TRexConstantModel trexConstantModel) async {
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
        final regex = RegExp(r'<<rptr constant:\s*(\S+)\s*/rptr>>');
        String updatedContent = model.content ?? '';
        List<String> invalidConstants = [];

        // Replace matches
        updatedContent = updatedContent.replaceAllMapped(regex, (match) {
          String constantKey = match.group(1)?.trim() ?? '';

          if (trexConstantModel.data.containsKey(constantKey)) {
            // Replace with the constant value
            return trexConstantModel.data[constantKey]!;
          } else {
            // Record invalid constant and leave it unchanged
            invalidConstants.add(constantKey);
            return match.group(0)!; // Return the original match
          }
        });

        // Log invalid constants if any
        if (invalidConstants.isNotEmpty) {
          BotToast.showText(
              text: 'Invalid constants found: ${invalidConstants.join(", ")}');
        }

        // Save the updated content
        await file.writeAsString(updatedContent);
        print('Created file: $file with content');
      }
    }

    // Handle MEDIAFILE type
    if (model.directoryInstanceType == DirectoryInstanceType.MEDIAFILE) {
      if (model.copyLocation != null) {
        String finalLocation = trexStoragePath + model.copyLocation!;

        final sourceEntity = FileSystemEntity.typeSync(finalLocation);

        print("Source entity and it's type ${sourceEntity} - ${finalLocation}");

        if (sourceEntity == FileSystemEntityType.file) {
          // Copy file directly into the target directory
          final sourceFile = File(finalLocation);
          final destinationFile = File('$rootPath/${model.name}');
          if (await sourceFile.exists()) {
            await sourceFile.copy(destinationFile.path);
            print(
                'Copied MEDIAFILE: ${sourceFile.path} to ${destinationFile.path}');
          } else {
            print('Source file does not exist: ${sourceFile.path}');
          }
        } else if (sourceEntity == FileSystemEntityType.directory) {
          // Copy contents of the folder (but not the folder itself)

          final sourceDirectory = Directory(finalLocation);

          final destinationDirectory = Directory('$rootPath/${model.name}');

          copyDirectory(sourceDirectory, destinationDirectory);
          print(
              'Copied contents of FOLDER: ${sourceDirectory.path} to $rootPath/${model.name}');
        } else {
          print('Invalid source type: $finalLocation');
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
            child, trexConstantModel); // Recursive call
      }
    }
  }

  // // Helper function to copy contents of a directory (files and subdirectories)
  // Future<void> _copyDirectoryContents(
  //     Directory source, String destinationPath) async {
  //   // Iterate over the files and subdirectories inside the source directory
  //   await for (var entity in source.list()) {
  //     final relativePath =
  //         entity.uri.pathSegments.last; // Get last segment of the path
  //
  //     if (entity is File) {
  //       // Copy each file to the destination folder
  //       final destinationFile = File('$destinationPath/$relativePath');
  //       final destinationDir = destinationFile.parent;
  //
  //       // Create directories in the destination path if not exist
  //       if (!await destinationDir.exists()) {
  //         await destinationDir.create(recursive: true);
  //       }
  //
  //       await entity.copy(destinationFile.path);
  //       print('Copied file: ${entity.path} to ${destinationFile.path}');
  //     } else if (entity is Directory) {
  //       // Recursively copy the contents of subdirectories into the destination folder
  //       await _copyDirectoryContents(entity, '$destinationPath/$relativePath');
  //     }
  //   }
  // }

  void copyDirectory(Directory source, Directory destination) {
    // If the destination directory does not exist, create it
    if (!destination.existsSync()) {
      destination.createSync(recursive: true);
    }

    print(destination.listSync(recursive: true));

    // // Iterate over the contents of the source directory
    // for (var entity in source.listSync()) {
    //   var newDestination = Directory(
    //       '${destination.path}${Platform.pathSeparator}${entity.uri.pathSegments.last}');
    //
    //   if (entity is File) {
    //     // If it's a file, copy it to the destination
    //     entity.copySync(newDestination.path);
    //   } else if (entity is Directory) {
    //     // If it's a directory, recursively copy its contents
    //     copyDirectory(entity, newDestination);
    //   }
    // }
  }
}
