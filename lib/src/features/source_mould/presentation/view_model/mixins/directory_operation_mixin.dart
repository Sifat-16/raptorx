import 'package:bot_toast/bot_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:raptorx/src/core/dependency_injection/dependency_injection.dart';
import 'package:raptorx/src/core/enum/DirectoryInstanceType.dart';
import 'package:raptorx/src/features/source_mould/data/t_rex_model.dart';
import 'package:raptorx/src/features/source_mould/presentation/view/component/manual_file_screen.dart';
import 'package:raptorx/src/features/source_mould/presentation/view_model/source_mould_controller.dart';

mixin DirectoryOperationMixin {
  TRexModel handleTRexOperation({TRexModel? tRexModel}) {
    tRexModel ??= TRexModel();
    return tRexModel;
  }

  void createNewRootDirectory({required BuildContext context}) async {
    TextEditingController textEditingController = TextEditingController();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => ContentDialog(
        constraints: BoxConstraints(maxHeight: 300),
        title: const Text('Create Root Folder'),
        content: Center(
          child: InfoLabel(
            label: 'Enter Root Folder Name:',
            child: TextBox(
              maxLines: 1,
              controller: textEditingController,
              placeholder: 'Root Folder',
              expands: false,
            ),
          ),
        ),
        actions: [
          Button(
            child: const Text('Done'),
            onPressed: () {
              if (textEditingController.text.isEmpty) {
                return;
              }

              final validNameRegex = RegExp(r'^[a-zA-Z0-9_\- ]+$');

              if (!validNameRegex.hasMatch(textEditingController.text.trim())) {
                BotToast.showText(text: "Not a valid folder name");

                return;
              }
              TRexModel trexModel = TRexModel(
                  name: textEditingController.text.trim(),
                  directoryInstanceType: DirectoryInstanceType.FOLDER);
              container
                  .read(sourceMouldProvider.notifier)
                  .updateTRexModel(tRexModel: trexModel);
              Navigator.pop(context);
              // Delete file here
            },
          ),
          FilledButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void createNewFolder(
      {required BuildContext context, required String parentId}) async {
    TextEditingController textEditingController = TextEditingController();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => ContentDialog(
        constraints: BoxConstraints(maxHeight: 300),
        title: const Text('Create New Folder'),
        content: Center(
          child: InfoLabel(
            label: 'Enter New Folder Name:',
            child: TextBox(
              maxLines: 1,
              controller: textEditingController,
              placeholder: 'New Folder',
              expands: false,
            ),
          ),
        ),
        actions: [
          Button(
            child: const Text('Done'),
            onPressed: () {
              if (textEditingController.text.isEmpty) {
                BotToast.showText(text: "Folder Name Can't be empty");

                return;
              }
              // final validNameRegex = RegExp(r'^[a-zA-Z0-9_\- ]+$');
              //
              // if (!validNameRegex.hasMatch(textEditingController.text.trim())) {
              //   BotToast.showText(text: "Not a valid folder name");
              //
              //   return;
              // }
              TRexModel trexModel = TRexModel(
                  name: textEditingController.text.trim(),
                  directoryInstanceType: DirectoryInstanceType.FOLDER);

              container
                  .read(sourceMouldProvider.notifier)
                  .createNewTRexInsideParent(
                      tRexModel: trexModel, parent: parentId);
              Navigator.pop(context);
              // Delete file here
            },
          ),
          FilledButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void createNewManualFile(
      {required BuildContext context,
      required TRexModel tRexModel,
      required String parentId}) {
    Navigator.push(
        context,
        FluentPageRoute(
            builder: (_) => ManualFileScreen(
                  tRexModel: tRexModel,
                  parentId: parentId,
                  isNewCreate: true,
                )));
  }

  void editNewManualFile(
      {required BuildContext context,
      required TRexModel tRexModel,
      required String parentId}) {
    Navigator.push(
        context,
        FluentPageRoute(
            builder: (_) => ManualFileScreen(
                  tRexModel: tRexModel,
                  parentId: parentId,
                  isNewCreate: false,
                )));
  }

  void deleteTRexOperation(
      {required BuildContext context, required String id}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => ContentDialog(
        constraints: BoxConstraints(maxHeight: 300),
        title: const Text('Are you sure?'),
        content: Center(
          child: Text("Everything inside this will be deleted"),
        ),
        actions: [
          Button(
            child: const Text('Done'),
            onPressed: () {
              container
                  .read(sourceMouldProvider.notifier)
                  .deleteResources(id: id);
              Navigator.pop(context);
              // Delete file here
            },
          ),
          FilledButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void createNewResourceFile(
      {required BuildContext context,
      required TRexModel tRexModel,
      required String parentId}) async {
    String? trexStorageDirectory =
        container.read(sourceMouldProvider).selectedTRexStorageDirectory;
    if (trexStorageDirectory == null) {
      BotToast.showText(text: "Select TrexStorage First");
      return;
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          initialDirectory: trexStorageDirectory, lockParentWindow: true);

      if (result == null || result.files.single.path == null) {
        BotToast.showText(text: "No File Is Selected");
        return;
      }

      String filePath = result.files.single.path!;

      if (filePath.startsWith(trexStorageDirectory)) {
        String filteredPath = filePath.split(trexStorageDirectory).last;
        TRexModel tRexModel = TRexModel(
            name: filteredPath.split("/").last,
            directoryInstanceType: DirectoryInstanceType.MEDIAFILE,
            copyLocation: filteredPath);

        container
            .read(sourceMouldProvider.notifier)
            .createNewTRexInsideParent(tRexModel: tRexModel, parent: parentId);
      } else {
        BotToast.showText(
            text:
                "Not a valid directory. Must be picked from valid TrexStorage");
      }
    }
  }
}
