import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/core/command_line_interface/command_line_interface.dart';
import 'package:raptorx/src/core/extractor/string_extractor.dart';
import 'package:raptorx/src/core/process_run/process_controller.dart';
import 'package:raptorx/src/features/brand_v2/brand_details/presentation/view_model/brand_details_controller.dart';
import 'package:raptorx/src/features/brand_v2/brands/data/model/brand_model.dart';

class BrandDetailsComponent extends ConsumerStatefulWidget {
  const BrandDetailsComponent({super.key, required this.brandModel});
  final BrandModel brandModel;

  @override
  ConsumerState<BrandDetailsComponent> createState() =>
      _BrandDetailsComponentState();
}

class _BrandDetailsComponentState extends ConsumerState<BrandDetailsComponent> {
  @override
  Widget build(BuildContext context) {
    final process1 = ref.watch(processProvider(1));
    // final process2 = ref.watch(processProvider(2));
    // final buildConfig = ref.watch(buildConfigProvider);
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: material.Card(
              elevation: 5,
              child: Row(
                children: <Widget>[
                  Container(
                    child: Image.file(File("${widget.brandModel.brandImage}")),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('${widget.brandModel.brandName}',
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Text('${widget.brandModel.brandLocation}'),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Button(
                                  child: const Text('Setup'),
                                  onPressed: () async {
                                    ref
                                        .read(brandDetailsProvider.notifier)
                                        .setupProject();
                                    // final notifier =
                                    //     ref.read(processProvider(3).notifier);
                                    // final setupRunCommand =
                                    //     "./setup_brand.sh ${widget.brandModel.brandName}";
                                    // await notifier.runCommand(
                                    //     command: setupRunCommand);
                                    //
                                    // print("Setup finished");
                                  }),
                              const SizedBox(
                                width: 20,
                              ),
                              Button(
                                  child: const Text('Setup & Run'),
                                  onPressed: () async {
                                    ref
                                        .read(brandDetailsProvider.notifier)
                                        .setupProject();
                                    // final notifier =
                                    //     ref.read(processProvider(3).notifier);
                                    // final setupRunCommand =
                                    //     "./setup_brand.sh ${widget.brandModel.brandName}";
                                    // await notifier.runCommand(
                                    //     command: setupRunCommand);
                                    //
                                    // print("Setup finished");
                                  }),
                              const SizedBox(
                                width: 20,
                              ),
                              Button(
                                  child: const Text('Clear'),
                                  onPressed: () {
                                    final notifier =
                                        ref.read(processProvider(3).notifier);
                                    final setupRunCommand =
                                        "./clear_brand.sh ${widget.brandModel.brandName}";
                                    notifier.runCommand(
                                        command: setupRunCommand);
                                    print("Clear finished");
                                  }),
                              const SizedBox(
                                width: 20,
                              ),
                              Button(
                                  child: const Text('ios release'),
                                  onPressed: () {}),
                              const SizedBox(
                                width: 20,
                              ),
                              Button(
                                  child: const Text('Android release'),
                                  onPressed: () async {
                                    final notifier =
                                        ref.read(processProvider(1).notifier);

                                    final String releaseAndroid = await ref
                                        .read(brandDetailsProvider.notifier)
                                        .getAndroidReleaseCommand();

                                    // final releaseIos =
                                    //     "./setup_brand.sh ${widget.brandModel.brandName} && cd shared && cd ios && pod install --repo-update && fastlane release && cd .. && cd .. && ./clear_brand.sh ${widget.brandModel.brandName}";
                                    notifier.runCommand(
                                        command: releaseAndroid);
                                  }),
                              const SizedBox(
                                width: 20,
                              ),
                              Button(
                                  child: const Text('Android & iOS release'),
                                  onPressed: () {
                                    uploadIos();
                                    uploadAndroid();
                                  }),
                              const SizedBox(
                                width: 20,
                              ),
                              Button(
                                  child: const Text('Get Version'),
                                  onPressed: () async {
                                    String startMarker =
                                        "Ezy123321ResultExtractorStart";
                                    String endMarker =
                                        "Ezy123321ResultExtractorEnd";
                                    final notifier1 =
                                        ref.read(processProvider(1).notifier);

                                    try {
                                      await notifier1.runCommand(
                                          command: 'cd shared && cd android');
                                    } catch (e) {}

                                    try {
                                      await notifier1.runCommand(
                                          command:
                                              'fastlane get_version start_marker:$startMarker end_marker:$endMarker',
                                          dataExtractor: (s) {
                                            String? extractedValue =
                                                StringExtractor.extract(
                                                    start: startMarker,
                                                    end: endMarker,
                                                    terminalOutput: s);
                                            if (extractedValue != null) {
                                              BotToast.showText(
                                                  text: extractedValue);
                                            }
                                          });
                                    } catch (e) {}

                                    try {
                                      await notifier1.runCommand(
                                          command: 'cd .. && cd ..');
                                    } catch (e) {}
                                  }),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ) // To this line
                ],
              ),
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CommandLineInterface(pid: 1),
              // CommandLineInterface(
              //   pid: 2,
              // ),
              // CommandLineInterface(
              //   pid: 3,
              // ),
            ],
          )
        ],
      ),
    );
  }

  uploadIos() {
    final notifier = ref.read(processProvider(1).notifier);
    const releaseIos =
        "cd shared && cd ios && pod install --repo-update && fastlane release && cd .. && cd ..";
    notifier.runCommand(command: releaseIos);
  }

  uploadAndroid() {
    final notifier = ref.read(processProvider(2).notifier);
    const releaseIos =
        "cd shared && cd android && fastlane deploy && cd .. && cd ..";
    notifier.runCommand(command: releaseIos);
  }
}
