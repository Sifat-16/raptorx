class StoreVersionModel {
  int major;
  int minor;
  int patch;
  int versionCode;

  StoreVersionModel({
    required this.major,
    required this.minor,
    required this.patch,
    required this.versionCode,
  });

  @override
  String toString() {
    return "($major.$minor.$patch) $versionCode";
  }
}
