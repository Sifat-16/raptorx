import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/features/source_mould/data/t_rex_constant_model.dart';
import 'package:raptorx/src/features/source_mould/presentation/view_model/source_mould_controller.dart';

class TRexConstants extends ConsumerStatefulWidget {
  // Constructor to accept the TRexModel
  const TRexConstants({Key? key}) : super(key: key);

  @override
  _TRexConstantsState createState() => _TRexConstantsState();
}

class _TRexConstantsState extends ConsumerState<TRexConstants> {
  @override
  Widget build(BuildContext context) {
    final source = ref.watch(sourceMouldProvider);
    // Access the TRexModel passed to the widget
    TRexConstantModel? rootModel = source.tRexConstantModel;

    return rootModel == null
        ? Row(
            children: [
              Button(
                  onPressed: () {
                    ref
                        .read(sourceMouldProvider.notifier)
                        .createNewConstantRoot(context: context);
                  },
                  child: Text("Create A New Constant File")),
              Button(
                  onPressed: () {
                    ref
                        .read(sourceMouldProvider.notifier)
                        .importTRexConstant(context: context);
                  },
                  child: Text("Import")),
            ],
          )
        : _buildTree(rootModel);
  }

  // Recursive function to build the tree structure
  Widget _buildTree(TRexConstantModel? model) {
    return Expander(
      header: model?.name == null ? SizedBox.shrink() : Text(model?.name ?? ""),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Button(
              onPressed: () {
                ref
                    .read(sourceMouldProvider.notifier)
                    .exportTRexConstant(context: context);
              },
              child: Text("Export")),
          IconButton(
              icon: Icon(FluentIcons.add),
              onPressed: () {
                ref
                    .read(sourceMouldProvider.notifier)
                    .addTRexConstants(context: context);
              }),
          IconButton(
              icon: Icon(FluentIcons.delete),
              onPressed: () {
                ref.read(sourceMouldProvider.notifier).deleteTRexConstants();
              }),
        ],
      ),
      content: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: model?.data.length,
          itemBuilder: (context, index) {
            final entry = model?.data.entries.elementAt(index);
            return ListTile(
              title: Text(entry?.key ?? ""),
              subtitle: Text(entry?.value ?? ""),
              trailing: Row(
                children: [
                  IconButton(
                      icon: Icon(FluentIcons.edit),
                      onPressed: () {
                        ref.read(sourceMouldProvider.notifier).addTRexConstants(
                            context: context,
                            toUpdate: {entry?.key ?? "": entry?.value ?? ""});
                      }),
                  IconButton(
                      icon: Icon(FluentIcons.delete),
                      onPressed: () {
                        ref
                            .read(sourceMouldProvider.notifier)
                            .deleteTRexConstant(
                                context: context, key: entry?.key ?? "");
                      }),
                ],
              ),
            );
          }),
    );
  }
}
