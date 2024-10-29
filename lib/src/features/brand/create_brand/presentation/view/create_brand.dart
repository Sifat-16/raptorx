import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/features/brand/create_brand/presentation/view_model/create_brand_controller.dart';

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
              decoration: BoxDecoration(),
              placeholder: "Brand Name",
            ),
            SizedBox(
              height: 15,
            ),
            TextBox(
              controller: brandNameController,
              decoration: BoxDecoration(),
              placeholder: "Package name",
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
