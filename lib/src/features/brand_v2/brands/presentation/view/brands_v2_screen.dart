import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/core/directory/directory_selection.dart';
import 'package:raptorx/src/features/brand_v2/brands/data/model/brand_model.dart';
import 'package:raptorx/src/features/brand_v2/brands/presentation/view/components/brand_card.dart';
import 'package:raptorx/src/features/brand_v2/brands/presentation/view_model/brands_v2_controller.dart';

class BrandsV2Screen extends ConsumerStatefulWidget {
  const BrandsV2Screen({super.key});

  @override
  ConsumerState<BrandsV2Screen> createState() => _BrandsV2ScreenState();
}

class _BrandsV2ScreenState extends ConsumerState<BrandsV2Screen> {
  @override
  Widget build(BuildContext context) {
    final brandV2 = ref.watch(brandsV2Provider);
    return ScaffoldPage(
      header: PageHeader(
        title: Text("Brands"),
        commandBar: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                icon: Icon(FluentIcons.refresh),
                onPressed: () {
                  ref
                      .read(brandsV2Provider.notifier)
                      .fetchAllBrands(refresh: true);
                }),
          ],
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            DirectorySelection(
                sourceLocation: brandV2.sourceLocation,
                onDirectorySelect: (location) {
                  ref
                      .read(brandsV2Provider.notifier)
                      .updateSourceLocation(location: location);
                },
                title:
                    "Select Core Directory ( It will consist of brands, global & production folder"),
            SizedBox(
              height: 30,
            ),
            GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                ...List.generate(brandV2.brands.length, (index) {
                  BrandModel brandModel = brandV2.brands[index];
                  return BrandCard(brandModel: brandModel);
                })
              ],
            )
          ],
        ),
      ),
    );
  }
}
