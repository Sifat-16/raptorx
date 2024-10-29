import 'dart:math';

import 'package:raptorx/src/core/dependency_injection/dependency_injection.dart';
import 'package:raptorx/src/core/process_run/process_controller.dart';
import 'package:raptorx/src/features/brand/brands/data/model/brand_model.dart';

class VersionExtractor {
  getPlayStoreVersion({required BrandModel brand}) async {
    final processor =
        container.read(processProvider(Random().nextInt(10000000)).notifier);
  }
}
