import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectSourceCode extends ConsumerStatefulWidget {
  const SelectSourceCode(
      {super.key, required this.sourceCode, required this.onTapSelect});
  final String? sourceCode;
  final Function onTapSelect;

  @override
  ConsumerState<SelectSourceCode> createState() => _SelectSourceCodeState();
}

class _SelectSourceCodeState extends ConsumerState<SelectSourceCode> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select Source Code"),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: TextBox(
                enabled: false,
                placeholder: widget.sourceCode ?? "Select Source Code",
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
            ),
            Button(
              child: const Text("Select"),
              onPressed: () => widget.onTapSelect(),
            )
          ],
        ),
      ],
    );
  }
}
