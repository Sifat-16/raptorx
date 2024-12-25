import 'package:bot_toast/bot_toast.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/core/enum/DirectoryInstanceType.dart';
import 'package:raptorx/src/features/source_mould/data/t_rex_model.dart';
import 'package:raptorx/src/features/source_mould/presentation/view_model/source_mould_controller.dart';

class ManualFileScreen extends ConsumerStatefulWidget {
  const ManualFileScreen(
      {super.key,
      required this.tRexModel,
      required this.parentId,
      required this.isNewCreate});

  final TRexModel tRexModel;
  final String parentId;
  final bool isNewCreate;

  @override
  ConsumerState<ManualFileScreen> createState() => _ManualFileScreenState();
}

class _ManualFileScreenState extends ConsumerState<ManualFileScreen> {
  TextEditingController fileNameController = TextEditingController();
  TextEditingController fileContentController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    initiateValues();
    super.initState();
  }

  initiateValues() {
    if (!widget.isNewCreate) {
      fileNameController.text = widget.tRexModel.name ?? "";
      fileContentController.text = widget.tRexModel.content ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        title: Text(widget.isNewCreate ? "Add File" : "Edit File"),
        commandBar: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                icon: Icon(
                  FluentIcons.save,
                  size: 25,
                ),
                onPressed: () {
                  if (fileNameController.text.isEmpty) {
                    BotToast.showText(text: "Need a file name");
                    return;
                  }
                  TRexModel tRexModel = widget.tRexModel;
                  tRexModel.directoryInstanceType = DirectoryInstanceType.FILE;
                  tRexModel.name = fileNameController.text.trim();
                  tRexModel.content = fileContentController.text.trim();

                  List<String> invalidConstants = ref
                      .read(sourceMouldProvider.notifier)
                      .checkValidConstant(content: tRexModel.content ?? "");

                  if (invalidConstants.isEmpty) {
                    if (widget.isNewCreate) {
                      ref
                          .read(sourceMouldProvider.notifier)
                          .createNewTRexInsideParent(
                              tRexModel: tRexModel, parent: widget.parentId);
                    } else {
                      ref
                          .read(sourceMouldProvider.notifier)
                          .updateNewTRexInsideParent(
                              tRexModel: tRexModel, parent: widget.parentId);
                    }
                  } else {
                    BotToast.showText(
                        text: "Invalid constants ${invalidConstants}");
                  }
                }),
            SizedBox(
              width: 20,
            ),
            IconButton(
                icon: Icon(
                  FluentIcons.delete,
                  size: 25,
                ),
                onPressed: () {}),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              icon: Icon(FluentIcons.back),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            InfoLabel(
              label: widget.isNewCreate
                  ? 'Enter New File Name:'
                  : 'Edit File Name:',
              child: TextBox(
                maxLines: 1,
                controller: fileNameController,
                placeholder: widget.isNewCreate ? 'New File' : 'Edit File',
                expands: false,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InfoLabel(
              label: 'Enter File Content:',
              child: TextBox(
                maxLines: null,
                controller: fileContentController,
                placeholder: 'File Content',
                expands: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
