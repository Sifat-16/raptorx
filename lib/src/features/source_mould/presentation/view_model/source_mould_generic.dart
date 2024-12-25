import 'package:raptorx/src/features/source_mould/data/t_rex_constant_model.dart';
import 'package:raptorx/src/features/source_mould/data/t_rex_model.dart';

class SourceMouldGeneric {
  String? selectedDirectory;
  String? selectedTRexStorageDirectory;
  TRexModel? tRexModel;
  TRexConstantModel? tRexConstantModel;
  bool eraseConstantModel;

  SourceMouldGeneric(
      {this.selectedDirectory,
      this.tRexModel,
      this.eraseConstantModel = false,
      this.selectedTRexStorageDirectory,
      this.tRexConstantModel});

  SourceMouldGeneric update(
      {String? selectedDirectory,
      TRexModel? tRexModel,
      bool? eraseConstantModel,
      String? selectedTRexStorageDirectory,
      TRexConstantModel? tRexConstantModel}) {
    SourceMouldGeneric sourceMouldGeneric = SourceMouldGeneric(
        selectedDirectory: selectedDirectory ?? this.selectedDirectory,
        tRexModel: tRexModel ?? this.tRexModel,
        eraseConstantModel: eraseConstantModel ?? this.eraseConstantModel,
        selectedTRexStorageDirectory:
            selectedTRexStorageDirectory ?? this.selectedTRexStorageDirectory,
        tRexConstantModel: tRexConstantModel ?? this.tRexConstantModel);
    if (eraseConstantModel == true) {
      sourceMouldGeneric.tRexConstantModel = null;
      sourceMouldGeneric.eraseConstantModel = false;
    }
    return sourceMouldGeneric;
  }
}
