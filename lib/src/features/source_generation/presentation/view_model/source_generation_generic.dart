import 'package:raptorx/src/features/source_mould/data/t_rex_model.dart';

class SourceGenerationGeneric {
  String? selectedLocationToGenerate;
  String? trexStoragePath;
  TRexModel? tRexModel;

  SourceGenerationGeneric(
      {this.selectedLocationToGenerate, this.tRexModel, this.trexStoragePath});

  SourceGenerationGeneric update(
      {String? selectedLocationToGenerate,
      TRexModel? tRexModel,
      String? trexStoragePath}) {
    return SourceGenerationGeneric(
        selectedLocationToGenerate:
            selectedLocationToGenerate ?? this.selectedLocationToGenerate,
        tRexModel: tRexModel ?? this.tRexModel,
        trexStoragePath: trexStoragePath ?? this.trexStoragePath);
  }
}
