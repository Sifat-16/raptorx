import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/core/build_config/build_controller.dart';
import 'package:raptorx/src/features/brand/brands/data/model/brand_model.dart';

import 'package:raptorx/src/features/settings/data/model/build_config_model.dart';

import 'brand_generic.dart';

final brandProvider = StateNotifierProvider<BrandController, BrandGeneric>((ref)=>BrandController(ref));

class BrandController extends StateNotifier<BrandGeneric>{
  BrandController(this.ref):super(BrandGeneric());
  Ref ref;

  Future<List<BrandModel>> fetchBrands(String? sourceCodeLocation)async{

    List<BrandModel> brands = [];

    if(sourceCodeLocation!=null){
      String brandedAppsPath = '$sourceCodeLocation/branded_apps';

      Directory brandedAppsDirectory = Directory(brandedAppsPath);

      if (await brandedAppsDirectory.exists()) {
        print("Directory exists - ${brandedAppsDirectory.path}");
        List<BrandModel> subdirectories = [];

        brandedAppsDirectory.listSync().forEach((entity) {
          if (entity is Directory) {
            subdirectories.add(
                BrandModel(
                    brandName:entity.path.split('/').last,
                    brandLocation: entity.path,
                    brandImage: "${entity.path}/android/app/src/main/ic_launcher-playstore.png"
                )
            );

          }
        });

        brands = subdirectories;

        state = state.update(brands: brands);

      }else{

        BotToast.showText(text: "No source code Found");
      }
    }



    return brands;


  }

}