import 'package:raptorx/src/features/source_mould/data/t_rex_constant_model.dart';
import 'package:raptorx/src/features/source_mould/data/t_rex_model.dart';

class SourceGenerationGeneric {
  String? selectedLocationToGenerate;
  String? trexStoragePath;
  TRexConstantModel? tRexConstantModel;
  TRexModel? tRexModel;

  SourceGenerationGeneric(
      {this.selectedLocationToGenerate,
      this.tRexModel,
      this.trexStoragePath,
      this.tRexConstantModel});

  SourceGenerationGeneric update(
      {String? selectedLocationToGenerate,
      TRexModel? tRexModel,
      TRexConstantModel? tRexConstantModel,
      String? trexStoragePath}) {
    return SourceGenerationGeneric(
        selectedLocationToGenerate:
            selectedLocationToGenerate ?? this.selectedLocationToGenerate,
        tRexModel: tRexModel ?? this.tRexModel,
        trexStoragePath: trexStoragePath ?? this.trexStoragePath,
        tRexConstantModel: tRexConstantModel ?? this.tRexConstantModel);
  }
}
