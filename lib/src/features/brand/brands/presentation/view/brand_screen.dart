import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/core/build_config/build_controller.dart';
import 'package:raptorx/src/features/brand/brands/data/model/brand_model.dart';
import 'package:raptorx/src/features/brand/brands/presentation/view_model/brand_controller.dart';

import 'components/brand_card.dart';

class BrandScreen extends ConsumerStatefulWidget {
  const BrandScreen({super.key});
  @override
  ConsumerState<BrandScreen> createState() => _BrandScreenState();
}

class _BrandScreenState extends ConsumerState<BrandScreen> {
  @override
  Widget build(BuildContext context) {
    final buildController = ref.watch(buildConfigProvider);
    return ScaffoldPage.withPadding(
      content: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: ref.read(brandProvider.notifier).fetchBrands(
                    buildController.buildConfigModel?.sourceCodeDirectory),
                builder: (context, snapshot) {
                  List<BrandModel> brands = snapshot.data ?? [];
                  if (brands.isEmpty) {
                    return const Center(
                      child: Text("No brands"),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Brands - ${brands.length}"),
                      const SizedBox(
                        height: 20,
                      ),
                      GridView.count(
                        crossAxisCount: 7,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        children: [
                          ...List.generate(brands.length, (index) {
                            BrandModel brandModel = brands[index];
                            return BrandCard(brandModel: brandModel);
                          })
                        ],
                      )
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }
}
