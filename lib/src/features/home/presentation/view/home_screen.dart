import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/core/build_config/build_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  //NavigationPanelItems _navigationPanelItems = NavigationPanelItems();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((tm) {
      ref.read(buildConfigProvider.notifier).fetchSourceCodeDirectory();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final homeController = ref.watch(homeProvider);
    // return NavigationView(
    //   appBar: const NavigationAppBar(
    //     title: Text('Raptor-X'),
    //   ),
    //   pane: NavigationPane(
    //     selected: homeController.topIndex,
    //     onChanged: ref.read(homeProvider.notifier).updateTopIndex,
    //     displayMode: homeController.displayMode,
    //     items: _navigationPanelItems.items,
    //     footerItems: _navigationPanelItems.footer,
    //   ),
    // );
    return ScaffoldPage.withPadding(
      header: const Text("Home"),
      content: const SingleChildScrollView(),
    );
  }
}
