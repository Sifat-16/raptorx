import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/core/directory/directory_handler.dart';
import 'package:raptorx/src/features/brand_v2/brands/data/model/brand_model.dart';
import 'package:raptorx/src/features/brand_v2/brands/presentation/view_model/brands_v2_generic.dart';

final brandsV2Provider =
    StateNotifierProvider<BrandsV2Controller, BrandsV2Generic>(
        (ref) => BrandsV2Controller());

class BrandsV2Controller extends StateNotifier<BrandsV2Generic> {
  BrandsV2Controller() : super(BrandsV2Generic());

  fetchAllBrands({String? raptorHub, bool refresh = false}) {
    if (refresh == true) {
      String? mainD = state.sourceLocation;
      if (mainD == null) {
        BotToast.showText(text: "Select Brand Directory First");
      } else {
        raptorHub = mainD;
        state = state.update(brands: []);
      }
    }

    try {
      Directory directory = Directory("${raptorHub}/brands");
      List<FileSystemEntity> brandFiles = directory.listSync();

      state = state.update(brands: []);

      for (var entity in brandFiles) {
        if (entity is Directory) {
          try {
            Directory raptor = Directory("${entity.path}/raptor");
            String jsonPath = "${raptor.path}/brand.json";
            File jsonFile = File(jsonPath);
            final jsonString = jsonFile.readAsStringSync();

            final Map<String, dynamic> jsonData = jsonDecode(jsonString);
            BrandModel brandModel = BrandModel.fromJson(jsonData);
            brandModel.brandImage =
                "$raptorHub/${brandModel.brandLocation}/${brandModel.brandImage}";
            List<BrandModel> brands = state.brands.toList();

            brands.add(brandModel);
            state = state.update(brands: brands);
          } catch (e) {
            BotToast.showText(text: e.toString());
          }
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void updateSourceLocation({required String location}) {
    bool exists = DirectoryHandler.checkValidDirectory(location: location);

    if (exists) {
      String brands = "$location/brands";

      String global = "$location/global";

      if (DirectoryHandler.checkValidDirectory(location: brands) &&
          DirectoryHandler.checkValidDirectory(location: global)) {
        state = state.update(sourceLocation: location);

        fetchAllBrands(raptorHub: location);
      } else {
        BotToast.showText(
            text: "Invalid directory.brands or global folder is not present.");
      }
    }
  }
}
