import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:raptorx/src/core/process_run/process_controller.dart';
import 'package:raptorx/src/features/brand_v2/brand_details/presentation/view_model/brand_details_generic.dart';
import 'package:raptorx/src/features/brand_v2/brands/data/model/brand_model.dart';
import 'package:raptorx/src/features/brand_v2/brands/presentation/view_model/brands_v2_controller.dart';
import 'package:raptorx/src/features/source_generation/presentation/view_model/source_generation_controller.dart';

final brandDetailsProvider =
    StateNotifierProvider<BrandDetailsController, BrandDetailsGeneric>(
        (ref) => BrandDetailsController(ref));

class BrandDetailsController extends StateNotifier<BrandDetailsGeneric> {
  BrandDetailsController(this.ref) : super(BrandDetailsGeneric());
  Ref ref;

  void updateBrandModel({required BrandModel brandModel}) {
    print(
        "Called with brand model update ${brandModel.brandLocation} - ${brandModel.currentAndroidVersion}");
    state = state.update(brandModel: brandModel);
  }

  void updateVersion({required String android, required String ios}) {
    String actualLocation =
        "${ref.read(brandsV2Provider).sourceLocation}${state.brandModel?.brandLocation}";
    File brandFile = File(actualLocation + "/brand.json");
    if (brandFile.existsSync()) {
      BrandModel? brandModel = state.brandModel;

      if (brandModel != null) {
        BrandModel updatedBrandModel = brandModel.copyWith(
            currentAndroidVersion: android,
            currentIosVersion: ios,
            brandImage: brandModel.brandImage?.split("/").last);

        String updatedJson = jsonEncode(updatedBrandModel.toJson());
        print(updatedJson);
        // // Convert the updated model to JSON and write it to the file
        brandFile.writeAsStringSync(updatedJson);

        final jsonString = brandFile.readAsStringSync();

        final Map<String, dynamic> jsonData = jsonDecode(jsonString);
        BrandModel updatedBrandModelAfterSave = BrandModel.fromJson(jsonData);
        updatedBrandModelAfterSave.brandImage = brandModel.brandImage;
        state = state.update(brandModel: updatedBrandModelAfterSave);
      }
    } else {
      BotToast.showText(text: "There is no brand.json");
    }
  }

  setupProject() async {
    String sourceLocation = ref.read(brandsV2Provider).sourceLocation ?? "";
    String actualBrandLocation =
        "${sourceLocation}${state.brandModel?.brandLocation}";
    Directory productionDirectory =
        Directory(join(sourceLocation, "production"));

    Directory duplicateDirectoryToDelete = Directory(
        join(sourceLocation, "production", "${state.brandModel?.brandName}"));

    if (duplicateDirectoryToDelete.existsSync()) {
      duplicateDirectoryToDelete.deleteSync(recursive: true);
      await Future.delayed(Duration(seconds: 5));
    }

    productionDirectory.createSync();
    await ref.read(sourceGenerationProvider.notifier).createSourceCodeFromBrand(
        brandLocation: actualBrandLocation, createAt: productionDirectory.path);

    //copy lib folder from global to project
    Directory productionBrandDirectory = Directory(
        join(productionDirectory.path, "${state.brandModel?.brandName}"));
    Directory copyFromLibDirectory =
        Directory(join(sourceLocation, "global", "lib"));

    Directory copyToLibDirectory =
        Directory(join(productionBrandDirectory.path, "lib"));
    if (!copyToLibDirectory.existsSync()) {
      copyToLibDirectory.createSync(recursive: true);
    }
    if (copyFromLibDirectory.existsSync()) {
      ref
          .read(sourceGenerationProvider.notifier)
          .copyDirectory(copyFromLibDirectory, copyToLibDirectory);
    } else {
      print("Lib directory doesn't exists");
    }

    //copy assets from global to project

    Directory copyFromAssetDirectory =
        Directory(join(sourceLocation, "global", "assets"));

    Directory copyToAssetDirectory =
        Directory(join(productionBrandDirectory.path, "assets"));
    if (!copyToAssetDirectory.existsSync()) {
      copyToAssetDirectory.createSync(recursive: true);
    }
    if (copyFromAssetDirectory.existsSync()) {
      ref
          .read(sourceGenerationProvider.notifier)
          .copyDirectory(copyFromAssetDirectory, copyToAssetDirectory);
    } else {}

    //brand_assets from brand to production assets
    Directory copyFromBrandAssetDirectory =
        Directory(join(actualBrandLocation, "brand_assets"));

    Directory copyToBrandAssetDirectory = Directory(
        join(productionBrandDirectory.path, "assets", "brand_assets"));
    if (!copyToBrandAssetDirectory.existsSync()) {
      copyToBrandAssetDirectory.createSync(recursive: true);
    }
    if (copyFromBrandAssetDirectory.existsSync()) {
      ref.read(sourceGenerationProvider.notifier).copyDirectory(
          copyFromBrandAssetDirectory, copyToBrandAssetDirectory);
    } else {}

    //mobilertc from global to android/mobilertc
    String copyFromMobileRTCANDROIDPath =
        join(sourceLocation, "global", "mobilertc.aar");

    String copyToMobileRTCANDROIDPath = join(
        productionBrandDirectory.path, "android", "mobilertc", "mobilertc.aar");

    print("${copyFromMobileRTCANDROIDPath} - ${copyToMobileRTCANDROIDPath}");

    ref
        .read(sourceGenerationProvider.notifier)
        .copyFile(copyFromMobileRTCANDROIDPath, copyToMobileRTCANDROIDPath);

    //appmode.dart from brand to production/brand/lib/services
    String copyFromAppModePath = join(actualBrandLocation, "app_mode.dart");

    String copyToAppModePath =
        join(productionBrandDirectory.path, "lib", "services", "app_mode.dart");

    print("app mode ${copyFromAppModePath} - ${copyToAppModePath}");

    ref
        .read(sourceGenerationProvider.notifier)
        .copyFile(copyFromAppModePath, copyToAppModePath);

    //k_colors.dart from brand to production/brand/lib/view/styles
    String copyFromKColorPath = join(actualBrandLocation, "k_colors.dart");

    String copyToKColorPath = join(productionBrandDirectory.path, "lib",
        "views", "styles", "k_colors.dart");

    print("${copyFromKColorPath} - ${copyToKColorPath}");

    ref
        .read(sourceGenerationProvider.notifier)
        .copyFile(copyFromKColorPath, copyToKColorPath);

    //splash_screen.dart from brand to production/brand/lib/view/styles
    String copyFromSplashScreenPath =
        join(actualBrandLocation, "splash_screen.dart");

    String copyToSplashScreenPath = join(productionBrandDirectory.path, "lib",
        "views", "screens", "startup", "splash_screen.dart");

    print("${copyFromSplashScreenPath} - ${copyToSplashScreenPath}");

    ref
        .read(sourceGenerationProvider.notifier)
        .copyFile(copyFromSplashScreenPath, copyToSplashScreenPath);

    //asset_path_constatnts.dart from brand to production/brand/lib/view/styles
    String copyFromAssetPathConstantsPath =
        join(actualBrandLocation, "asset_path_constatnts.dart");

    String copyToAssetPathConstantsPath = join(productionBrandDirectory.path,
        "lib", "constants", "asset_path_constatnts.dart");

    print(
        "${copyFromAssetPathConstantsPath} - ${copyToAssetPathConstantsPath}");

    ref
        .read(sourceGenerationProvider.notifier)
        .copyFile(copyFromAssetPathConstantsPath, copyToAssetPathConstantsPath);

    // MobileRTCXcframework from global to brand/ios

    Directory copyFromMobileRTCXcframeworkDirectory =
        Directory(join(sourceLocation, "global", "MobileRTC.xcframework"));

    Directory copyToMobileRTCXcframeworkDirectory =
        Directory(join(productionBrandDirectory.path, "ios"));
    if (!copyToMobileRTCXcframeworkDirectory.existsSync()) {
      copyToMobileRTCXcframeworkDirectory.createSync(recursive: true);
    }
    if (copyFromMobileRTCXcframeworkDirectory.existsSync()) {
      String command =
          "rsync -ahP ${copyFromMobileRTCXcframeworkDirectory.path.replaceAll("/Volumes/Macintosh HD", "")} ${copyToMobileRTCXcframeworkDirectory.path.replaceAll("/Volumes/Macintosh HD", "")}";
      await ref
          .read(processProvider("rtc_copy").notifier)
          .runCommand(command: command);
    } else {}

    // MobileRTCResources from global to brand/ios

    Directory copyFromMobileRTCResourceDirectory =
        Directory(join(sourceLocation, "global", "MobileRTCResources.bundle"));

    Directory copyToMobileRTCResourceDirectory =
        Directory(join(productionBrandDirectory.path, "ios"));
    if (!copyToMobileRTCResourceDirectory.existsSync()) {
      copyToMobileRTCResourceDirectory.createSync(recursive: true);
    }
    if (copyFromMobileRTCResourceDirectory.existsSync()) {
      String command =
          "rsync -ahP ${copyFromMobileRTCResourceDirectory.path.replaceAll("/Volumes/Macintosh HD", "")} ${copyToMobileRTCResourceDirectory.path.replaceAll("/Volumes/Macintosh HD", "")}";
      await ref
          .read(processProvider("rtc_copy").notifier)
          .runCommand(command: command);
    } else {}

    await Future.delayed(Duration(seconds: 1));
  }

  Future<String> getAndroidReleaseCommand() async {
    await setupProject();
    String sourceLocation = ref.read(brandsV2Provider).sourceLocation ?? "";
    Directory productionDirectory =
        Directory(join(sourceLocation, "production"));
    Directory productionBrandDirectory = Directory(
        join(productionDirectory.path, "${state.brandModel?.brandName}"));
    //&& cd android && fastlane release && cd..
    return "cd ${productionBrandDirectory.path.replaceAll("/Volumes/Macintosh HD", "")} && flutter pub get && flutter build appbundle && cd android && fastlane deploy && cd..";
  }

  getIOSReleaseCommand() async {
    await setupProject();
    String sourceLocation = ref.read(brandsV2Provider).sourceLocation ?? "";
    Directory productionDirectory =
        Directory(join(sourceLocation, "production"));
    Directory productionBrandDirectory = Directory(
        join(productionDirectory.path, "${state.brandModel?.brandName}"));
    //&& cd android && fastlane release && cd..
    // final releaseIos =
    //     "./setup_brand.sh ${widget.brandModel.brandName} && cd shared && cd ios && pod install --repo-update && fastlane release && cd .. && cd .. && ./clear_brand.sh ${widget.brandModel.brandName}";
    return "cd ${productionBrandDirectory.path.replaceAll("/Volumes/Macintosh HD", "")} && flutter pub get && cd ios && pod install --repo-update && fastlane release version:${state.brandModel!.currentIosVersion} && cd..";
  }
}
