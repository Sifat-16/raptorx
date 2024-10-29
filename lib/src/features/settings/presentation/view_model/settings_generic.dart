class SettingsGeneric{
  String? sourceCodeDirectory;
  SettingsGeneric({this.sourceCodeDirectory});

  SettingsGeneric update({
    String? sourceCodeDirectory
}){
    return SettingsGeneric(sourceCodeDirectory: sourceCodeDirectory??this.sourceCodeDirectory);
  }
}