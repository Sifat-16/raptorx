import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/core/process_run/process_controller.dart';

class ProcessorManager {
  Set<int> activeProcessors = {};

  StateNotifierProvider getNewProcessor() {
    int newProcessInt = generateRandomInt();

    if (activeProcessors.contains(newProcessInt)) {
      return getNewProcessor();
    }

    activeProcessors.add(newProcessInt);

    return processProvider(newProcessInt);
  }

  generateRandomInt() {
    return Random().nextInt(1000000000);
  }
}
