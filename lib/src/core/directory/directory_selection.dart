import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DirectorySelection extends ConsumerStatefulWidget {
  const DirectorySelection(
      {super.key,
      required this.sourceLocation,
      required this.onDirectorySelect,
      required this.title});
  final String? sourceLocation;
  final String title;
  final Function(String) onDirectorySelect;

  @override
  ConsumerState<DirectorySelection> createState() => _SelectSourceCodeState();
}

class _SelectSourceCodeState extends ConsumerState<DirectorySelection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: TextBox(
                enabled: false,
                placeholder: widget.sourceLocation ?? "Select Directory",
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
            ),
            Button(
              child: const Text("Select"),
              onPressed: () async {
                String? directoryPath =
                    await FilePicker.platform.getDirectoryPath();
                if (directoryPath != null) {
                  widget.onDirectorySelect(directoryPath);
                }
              },
            )
          ],
        ),
      ],
    );
  }
}
