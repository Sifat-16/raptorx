import 'package:fluent_ui/fluent_ui.dart';

class VersionEditor extends StatelessWidget {
  const VersionEditor({super.key, required this.platform});

  final String platform;

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
          Column(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: const Icon(FluentIcons.skype_minus),
                          onPressed: () {}),
                      const Expanded(child: TextBox()),
                      IconButton(
                          icon: const Icon(FluentIcons.add), onPressed: () {}),
                    ],
                  ),
                  const Text("Major"),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: const Icon(FluentIcons.skype_minus),
                          onPressed: () {}),
                      const Expanded(child: TextBox()),
                      IconButton(
                          icon: const Icon(FluentIcons.add), onPressed: () {}),
                    ],
                  ),
                  const Text("Minor"),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: const Icon(FluentIcons.skype_minus),
                          onPressed: () {}),
                      const Expanded(child: TextBox()),
                      IconButton(
                          icon: const Icon(FluentIcons.add), onPressed: () {}),
                    ],
                  ),
                  const Text("Patch"),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: const Icon(FluentIcons.skype_minus),
                          onPressed: () {}),
                      const Expanded(child: TextBox()),
                      IconButton(
                          icon: const Icon(FluentIcons.add), onPressed: () {}),
                    ],
                  ),
                  const Text("Version"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
