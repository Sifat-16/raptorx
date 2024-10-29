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
          Text("${platform}"),
          SizedBox(
            height: 10,
          ),
          Column(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: Icon(FluentIcons.skype_minus),
                          onPressed: () {}),
                      Expanded(child: TextBox()),
                      IconButton(icon: Icon(FluentIcons.add), onPressed: () {}),
                    ],
                  ),
                  Text("Major"),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: Icon(FluentIcons.skype_minus),
                          onPressed: () {}),
                      Expanded(child: TextBox()),
                      IconButton(icon: Icon(FluentIcons.add), onPressed: () {}),
                    ],
                  ),
                  Text("Minor"),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: Icon(FluentIcons.skype_minus),
                          onPressed: () {}),
                      Expanded(child: TextBox()),
                      IconButton(icon: Icon(FluentIcons.add), onPressed: () {}),
                    ],
                  ),
                  Text("Patch"),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: Icon(FluentIcons.skype_minus),
                          onPressed: () {}),
                      Expanded(child: TextBox()),
                      IconButton(icon: Icon(FluentIcons.add), onPressed: () {}),
                    ],
                  ),
                  Text("Version"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
