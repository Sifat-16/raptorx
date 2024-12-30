import 'package:fluent_ui/fluent_ui.dart';

class VersionEditor extends StatelessWidget {
  const VersionEditor(
      {super.key, required this.platform, required this.textEditingController});

  final String platform;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text(platform),
          const SizedBox(
            height: 10,
          ),
          TextBox(
            controller: textEditingController,
            decoration: BoxDecoration(),
            placeholder: "${platform} version (major.minor.patch+build)",
          )
        ],
      ),
    );
  }
}
