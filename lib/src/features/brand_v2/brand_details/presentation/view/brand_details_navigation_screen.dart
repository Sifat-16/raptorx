import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/features/brand_v2/brand_details/presentation/view/details/brand_details_component.dart';
import 'package:raptorx/src/features/brand_v2/brand_details/presentation/view/edit/brand_details_edit_component.dart';
import 'package:raptorx/src/features/brand_v2/brand_details/presentation/view/version/version_edit_component.dart';
import 'package:raptorx/src/features/brand_v2/brand_details/presentation/view_model/brand_details_controller.dart';
import 'package:raptorx/src/features/brand_v2/brands/data/model/brand_model.dart';

final brandDetailsNavigationIndex = StateProvider.autoDispose<int>((ref) => 0);

class BrandDetailsNavigationScreen extends ConsumerStatefulWidget {
  const BrandDetailsNavigationScreen({super.key, required this.brandModel});

  final BrandModel brandModel;

  @override
  ConsumerState<BrandDetailsNavigationScreen> createState() =>
      _BrandDetailsNavigationScreenState();
}

class _BrandDetailsNavigationScreenState
    extends ConsumerState<BrandDetailsNavigationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((t) {
      ref
          .read(brandDetailsProvider.notifier)
          .updateBrandModel(brandModel: widget.brandModel);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(brandDetailsNavigationIndex);

    return NavigationView(
      appBar: NavigationAppBar(
          leading: IconButton(
              icon: const Icon(
                FluentIcons.navigate_back,
                size: 25,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          title: Center(child: Text("Raptor Engine"))),
      pane: NavigationPane(
        selected: index,
        onChanged: (idx) =>
            ref.read(brandDetailsNavigationIndex.notifier).state = idx,
        displayMode: PaneDisplayMode.compact, // Drawer-like behavior
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.home),
            title: const Text('Brand Details'),
            body: BrandDetailsComponent(brandModel: widget.brandModel),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            title: const Text('Brand Mould Edit'),
            body: BrandDetailsEditComponent(brandModel: widget.brandModel),
          ),
          PaneItem(
              icon: const Icon(FluentIcons.settings),
              title: const Text('Brand Version Edit'),
              body: VersionEditComponent(brandModel: widget.brandModel)),
        ],
      ),
    );
  }
}
