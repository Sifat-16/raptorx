import 'package:bot_toast/bot_toast.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/features/brand_v2/brand_details/presentation/view_model/brand_details_controller.dart';
import 'package:raptorx/src/features/brand_v2/brands/data/model/brand_model.dart';
import 'package:raptorx/src/shared/presentation/components/version_editor.dart';

class VersionEditComponent extends ConsumerStatefulWidget {
  const VersionEditComponent({super.key, required this.brandModel});
  final BrandModel brandModel;

  @override
  ConsumerState<VersionEditComponent> createState() =>
      _VersionEditComponentState();
}

class _VersionEditComponentState extends ConsumerState<VersionEditComponent> {
  TextEditingController androidVersionController = TextEditingController();
  TextEditingController iosVersionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((t) {
      androidVersionController.text =
          widget.brandModel.currentAndroidVersion ?? "";
      iosVersionController.text = widget.brandModel.currentIosVersion ?? "";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VersionEditor(
            platform: "Android",
            textEditingController: androidVersionController),
        SizedBox(
          height: 30,
        ),
        VersionEditor(
            platform: "iOS", textEditingController: iosVersionController),
        SizedBox(
          height: 30,
        ),
        Button(
            child: Text("Save"),
            onPressed: () {
              if (effectiveVersionChecker(
                      androidVersionController.text.trim()) &&
                  effectiveVersionChecker(iosVersionController.text.trim())) {
                ref.read(brandDetailsProvider.notifier).updateVersion(
                    android: androidVersionController.text.trim(),
                    ios: iosVersionController.text.trim());
              } else {
                BotToast.showText(text: "Not effective version");
              }
            })
      ],
    );
  }

  bool effectiveVersionChecker(String version) {
    final regex = RegExp(r'^\d+\.\d+\.\d+\+\d+$');
    return regex.hasMatch(version);
  }
}
