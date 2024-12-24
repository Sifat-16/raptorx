import 'package:raptorx/src/features/source_mould/data/t_rex_model.dart';

class SourceMouldGeneric {
  String? selectedDirectory;
  String? selectedTRexStorageDirectory;
  TRexModel? tRexModel;

  SourceMouldGeneric(
      {this.selectedDirectory,
      this.tRexModel,
      this.selectedTRexStorageDirectory});

  SourceMouldGeneric update(
      {String? selectedDirectory,
      TRexModel? tRexModel,
      String? selectedTRexStorageDirectory}) {
    return SourceMouldGeneric(
        selectedDirectory: selectedDirectory ?? this.selectedDirectory,
        tRexModel: tRexModel ?? this.tRexModel,
        selectedTRexStorageDirectory:
            selectedTRexStorageDirectory ?? this.selectedTRexStorageDirectory);
  }
}
