import 'package:raptorx/src/features/brand/brands/data/model/brand_model.dart';

class BrandGeneric {
  List<BrandModel> brands;

  BrandGeneric({this.brands = const []});

  BrandGeneric update({List<BrandModel>? brands}) {
    return BrandGeneric(brands: brands ?? this.brands);
  }
}
