import 'dart:io';

import 'package:raptorx/src/core/directory/raptor_directory.dart';

class DirectoryHandler {
  static Future<List<RaptorDirectory>> fetchDirectoryFromLocation(
      {required String location}) async {
    Directory directory = Directory(location);
    List<RaptorDirectory> raptorDirectories = [];
    if (directory.existsSync()) {
      try {
        List<FileSystemEntity> files = directory.listSync();
        for (var entity in files) {
          RaptorDirectory raptorDirectory;
          if (entity is File) {
            raptorDirectory = RaptorDirectory(
                name: entity.path.split("/").last,
                location: entity.path,
                raptorDirectoryType: RaptorDirectoryType.FILE);
          } else {
            raptorDirectory = RaptorDirectory(
                name: entity.path.split("/").last,
                location: entity.path,
                raptorDirectoryType: RaptorDirectoryType.FOLDER);
          }
        }
      } catch (e) {}
    }
    return raptorDirectories;
  }
}
