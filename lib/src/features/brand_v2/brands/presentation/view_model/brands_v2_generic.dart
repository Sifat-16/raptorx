import 'package:raptorx/src/features/brand_v2/brands/data/model/brand_model.dart';

class BrandsV2Generic {
  String? sourceLocation;
  List<BrandModel> brands;

  BrandsV2Generic({this.sourceLocation, this.brands = const []});

  BrandsV2Generic update({String? sourceLocation, List<BrandModel>? brands}) {
    return BrandsV2Generic(
        sourceLocation: sourceLocation ?? this.sourceLocation,
        brands: brands ?? this.brands);
  }
}
