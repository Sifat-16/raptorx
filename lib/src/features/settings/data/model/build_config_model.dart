class BuildConfigModel {
  String? sourceCodeDirectory;

  BuildConfigModel({this.sourceCodeDirectory});

  // Convert a BuildConfigModel object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'sourceCodeDirectory': sourceCodeDirectory,
    };
  }

  // Create a BuildConfigModel object from a JSON map
  factory BuildConfigModel.fromJson(Map<String, dynamic> json) {
    return BuildConfigModel(
      sourceCodeDirectory: json['sourceCodeDirectory'] as String?,
    );
  }
}