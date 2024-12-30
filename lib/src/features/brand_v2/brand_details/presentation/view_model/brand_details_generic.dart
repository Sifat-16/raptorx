import 'package:raptorx/src/features/brand_v2/brands/data/model/brand_model.dart';

class BrandDetailsGeneric {
  BrandModel? brandModel;

  BrandDetailsGeneric({this.brandModel});

  BrandDetailsGeneric update({BrandModel? brandModel}) {
    return BrandDetailsGeneric(brandModel: brandModel ?? this.brandModel);
  }
}
