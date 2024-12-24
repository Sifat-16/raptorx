import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/features/brand/create_brand/presentation/view_model/create_brand_controller.dart';
import 'package:raptorx/src/rust/api/sif.dart';

class CreateBrand extends ConsumerStatefulWidget {
  const CreateBrand({super.key});

  @override
  ConsumerState<CreateBrand> createState() => _CreateBrandState();
}

class _CreateBrandState extends ConsumerState<CreateBrand> {
  TextEditingController brandNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final createBrand = ref.watch(createBrandProvider);
    return ScaffoldPage.withPadding(
      header: const PageHeader(
        title: Text("Create Brand"),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextBox(
              controller: brandNameController,
              decoration: const BoxDecoration(),
              placeholder: "Brand Name",
            ),
            const SizedBox(
              height: 15,
            ),
            TextBox(
              controller: brandNameController,
              decoration: const BoxDecoration(),
              placeholder: "Package name",
            ),
            const SizedBox(
              height: 15,
            ),
            Button(
                child: Text("Check rust"),
                onPressed: () {
                  print(compareMillion(value: BigInt.parse("10000000")));
                }),
            Button(
                child: Text("Check dart"),
                onPressed: () {
                  DateTime start = DateTime.now();
                  for (int i = 0; i < 10000000; i++) {
                    print("Current number: ${i}");
                  }
                  DateTime end = DateTime.now();
                  print("${end.difference(start).inMilliseconds}");
                })
          ],
        ),
      ),
    );
  }
}
