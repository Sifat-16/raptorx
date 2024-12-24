import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/core/build_config/build_controller.dart';
import 'package:raptorx/src/features/settings/presentation/view/components/select_source_code.dart';
import 'package:raptorx/src/features/settings/presentation/view_model/settings_controller.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _BrandScreenState();
}

class _BrandScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final settingsController = ref.watch(settingsProvider);
    final buildController = ref.watch(buildConfigProvider);

    return ScaffoldPage.withPadding(
      header: const PageHeader(title: Text('Settings')),
      content: SingleChildScrollView(
        child: Column(
          children: [
            SelectSourceCode(
              sourceCode: buildController.buildConfigModel?.sourceCodeDirectory,
              onTapSelect: () {
                ref.watch(settingsProvider.notifier).onSelectSourceCode();
              },
            )
          ],
        ),
      ),
    );
  }
}
