import 'package:bot_toast/bot_toast.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/core/directory/directory_selection.dart';
import 'package:raptorx/src/features/brand_v2/brands/data/model/brand_model.dart';
import 'package:raptorx/src/features/source_mould/presentation/view/component/t_rex_constants.dart';
import 'package:raptorx/src/features/source_mould/presentation/view/component/t_rex_tree.dart';
import 'package:raptorx/src/features/source_mould/presentation/view_model/source_mould_controller.dart';

class SourceMouldScreen extends ConsumerStatefulWidget {
  const SourceMouldScreen({super.key, this.brandModel});

  final BrandModel? brandModel;

  @override
  ConsumerState<SourceMouldScreen> createState() => _SourceMouldScreenState();
}

class _SourceMouldScreenState extends ConsumerState<SourceMouldScreen> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((t) {
      setupSourceMouldIfBrandPresent();
    });
    super.initState();
  }

  setupSourceMouldIfBrandPresent() {
    BrandModel? brandModel = widget.brandModel;
    if (brandModel != null) {
      ref
          .read(sourceMouldProvider.notifier)
          .initiateMould(brandModel: brandModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sourceMould = ref.watch(sourceMouldProvider);
    return ScaffoldPage.withPadding(
      header: PageHeader(
        title: const Text("Source Mould"),
        commandBar: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () {
                  ref
                      .read(sourceMouldProvider.notifier)
                      .importTRexModelWithCustomExtension();
                },
                child: const Text("Import")),
            TextButton(
                onPressed: () {
                  ref
                      .read(sourceMouldProvider.notifier)
                      .exportTRexModelWithCustomExtension();
                },
                child: const Text("Export")),
          ],
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DirectorySelection(
                title: "Select Directory of T-Rex Storage",
                sourceLocation: sourceMould.selectedTRexStorageDirectory,
                onDirectorySelect: (directory) {
                  String storageName = directory.split("/").last;
                  if (storageName == "TrexStorage") {
                    ref
                        .read(sourceMouldProvider.notifier)
                        .updateTRexStorageDirectory(directory: directory);
                  } else {
                    BotToast.showText(
                        text: "Storage Must be named as TrexStorage");
                  }
                }),
            SizedBox(
              height: 20,
            ),
            TRexConstants(),
            SizedBox(
              height: 20,
            ),
            TRexModelTree()
          ],
        ),
      ),
    );
  }
}
