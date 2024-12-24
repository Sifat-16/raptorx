enum RaptorDirectoryType { FILE, FOLDER }

class RaptorDirectory {
  String name;
  String location;
  RaptorDirectoryType raptorDirectoryType;
  RaptorDirectory(
      {required this.name,
      required this.location,
      required this.raptorDirectoryType});
}
