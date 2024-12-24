import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/core/enum/DirectoryInstanceType.dart';
import 'package:raptorx/src/features/source_mould/data/t_rex_model.dart';
import 'package:raptorx/src/features/source_mould/presentation/view_model/source_mould_controller.dart';

class TRexModelTree extends ConsumerStatefulWidget {
  // Constructor to accept the TRexModel
  const TRexModelTree({Key? key}) : super(key: key);

  @override
  _TRexModelTreeState createState() => _TRexModelTreeState();
}

class _TRexModelTreeState extends ConsumerState<TRexModelTree> {
  @override
  Widget build(BuildContext context) {
    final source = ref.watch(sourceMouldProvider);
    // Access the TRexModel passed to the widget
    TRexModel? rootModel = source.tRexModel;

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        if (rootModel == null)
          Button(
              onPressed: () {
                ref
                    .read(sourceMouldProvider.notifier)
                    .createNewRootDirectory(context: context);
              },
              child: Text("Create A Source Code"))
        else
          _buildTree(rootModel),
      ],
    );
  }

  // Recursive function to build the tree structure
  Widget _buildTree(TRexModel? model) {
    // If it's a file, show its content under the name

    if (model?.directoryInstanceType == DirectoryInstanceType.FILE ||
        model?.directoryInstanceType == DirectoryInstanceType.MEDIAFILE) {
      return Expander(
        header: Text(model?.name ?? ""),
        trailing: Row(
          children: [
            if (model?.directoryInstanceType == DirectoryInstanceType.FILE)
              IconButton(
                  icon: Icon(FluentIcons.edit),
                  onPressed: () {
                    ref.read(sourceMouldProvider.notifier).editNewManualFile(
                        context: context,
                        tRexModel: model!,
                        parentId: model.id ?? "");
                  }),
            IconButton(
                icon: Icon(FluentIcons.delete),
                onPressed: () {
                  ref.read(sourceMouldProvider.notifier).deleteTRexOperation(
                      context: context, id: model?.id ?? "");
                }),
          ],
        ),
        content: model?.content != null
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(model?.content ?? ""),
              )
            : SizedBox.shrink(),
      );
    }

    // If it's a folder, use Expander to allow expanding/collapsing
    return Expander(
      header: model?.name == null ? SizedBox.shrink() : Text(model?.name ?? ""),
      trailing: Row(
        children: [
          DropDownButton(
            title: Icon(FluentIcons.add),
            trailing: SizedBox.shrink(),
            items: [
              MenuFlyoutItem(
                  text: const Text('Add Folder'),
                  onPressed: () {
                    ref.read(sourceMouldProvider.notifier).createNewFolder(
                        context: context, parentId: model?.id ?? "");
                  }),
              MenuFlyoutSeparator(),
              MenuFlyoutItem(
                  text: const Text('Add Manual File'),
                  onPressed: () {
                    ref.read(sourceMouldProvider.notifier).createNewManualFile(
                        context: context,
                        tRexModel: TRexModel(),
                        parentId: model?.id ?? "");
                  }),
              MenuFlyoutSeparator(),
              MenuFlyoutItem(
                  text: const Text('Add Resource File'),
                  onPressed: () {
                    ref
                        .read(sourceMouldProvider.notifier)
                        .createNewResourceFile(
                            context: context,
                            tRexModel: TRexModel(),
                            parentId: model?.id ?? "");
                  }),
            ],
          ),

          IconButton(
              icon: Icon(FluentIcons.delete),
              onPressed: () {
                ref
                    .read(sourceMouldProvider.notifier)
                    .deleteTRexOperation(context: context, id: model?.id ?? "");
              })
          // IconButton(icon: Icon(FluentIcons.file_template), onPressed: () {})
        ],
      ),
      content: model?.tRexModel != null
          ? Column(
              children: model!.tRexModel!
                  .map<Widget>((child) => _buildTree(
                      child)) // Recursive call to handle nested items
                  .toList(),
            )
          : SizedBox.shrink(),
    );
  }
}
