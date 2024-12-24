import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/core/enum/DirectoryInstanceType.dart';
import 'package:raptorx/src/features/source_generation/presentation/view_model/source_generation_controller.dart';
import 'package:raptorx/src/features/source_mould/data/t_rex_model.dart';

class TRexGenerationTree extends ConsumerStatefulWidget {
  // Constructor to accept the TRexModel
  const TRexGenerationTree({Key? key}) : super(key: key);

  @override
  _TRexGenerationTreeState createState() => _TRexGenerationTreeState();
}

class _TRexGenerationTreeState extends ConsumerState<TRexGenerationTree> {
  @override
  Widget build(BuildContext context) {
    final source = ref.watch(sourceGenerationProvider);
    // Access the TRexModel passed to the widget
    TRexModel? rootModel = source.tRexModel;

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        if (rootModel == null) SizedBox.shrink() else _buildTree(rootModel),
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
