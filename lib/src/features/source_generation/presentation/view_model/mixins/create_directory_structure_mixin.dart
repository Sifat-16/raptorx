import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:path/path.dart';
import 'package:raptorx/src/core/enum/DirectoryInstanceType.dart';
import 'package:raptorx/src/features/source_mould/data/t_rex_constant_model.dart';
import 'package:raptorx/src/features/source_mould/data/t_rex_model.dart';

mixin CreateDirectoryStructureMixin {
  createDirectoryStructure(String rootPath, String trexStoragePath,
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
        await createDirectoryStructure('$rootPath/${model.name}',
            trexStoragePath, child, trexConstantModel); // Recursive call
      }
    }
  }

  void copyDirectory(Directory source, Directory destination) =>
      source.listSync(recursive: false).forEach((var entity) {
        if (entity is Directory) {
          var newDirectory =
              Directory(join(destination.absolute.path, basename(entity.path)));
          newDirectory.createSync(recursive: true);

          copyDirectory(entity.absolute, newDirectory);
        } else if (entity is File) {
          if (!destination.existsSync()) {
            destination.createSync(recursive: true);
          }

          try {
            entity.copySync(join(destination.path, basename(entity.path)));
          } catch (e) {
            print("Error while copying file ${e.toString()}");
          }
        }
      });

  void copyFile(String sourcePath, String destinationPath) {
    try {
      // Create a File object for the source file
      File sourceFile = File(sourcePath);

      // Check if the source file exists
      if (sourceFile.existsSync()) {
        // Create a File object for the destination
        File destinationFile = File(destinationPath);

        print("Destination file exists ${destinationFile.existsSync()}");
        // Copy the content of the source file to the destination
        sourceFile.copySync(destinationPath);

        print("File copied to $destinationPath");
      } else {
        print("Source file does not exist at $sourcePath");
      }
    } catch (e) {
      print("Error while copying file: $e");
    }
  }
}
