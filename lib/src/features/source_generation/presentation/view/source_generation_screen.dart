import 'package:bot_toast/bot_toast.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/core/directory/directory_selection.dart';
import 'package:raptorx/src/features/source_generation/presentation/view_model/source_generation_controller.dart';

import 'components/t_rex_generation_tree.dart';

class SourceGenerationScreen extends ConsumerStatefulWidget {
  const SourceGenerationScreen({super.key});

  @override
  ConsumerState<SourceGenerationScreen> createState() =>
      _SourceGenerationScreenState();
}

class _SourceGenerationScreenState
    extends ConsumerState<SourceGenerationScreen> {
  @override
  Widget build(BuildContext context) {
    final sourceGenerate = ref.watch(sourceGenerationProvider);
    return ScaffoldPage(
      header: PageHeader(
        title: Text("Generate Source Code"),
        commandBar: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () {
                  if (sourceGenerate.selectedLocationToGenerate == null) {
                    BotToast.showText(
                        text: "Select a directory to create the source code");
                    return;
                  } else {
                    ref
                        .read(sourceGenerationProvider.notifier)
                        .createSourceCode();
                  }
                },
                child: const Text("Generate"))
          ],
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            DirectorySelection(
                title: "Select Directory To Generate",
                sourceCode: sourceGenerate.selectedLocationToGenerate,
                onDirectorySelect: (directory) {
                  ref
                      .read(sourceGenerationProvider.notifier)
                      .updateDirectory(directory: directory);
                }),
            SizedBox(
              height: 20,
            ),
            TRexGenerationTree()
          ],
        ),
      ),
    );
  }
}
