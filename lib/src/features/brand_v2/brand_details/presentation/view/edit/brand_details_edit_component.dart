import 'package:fluent_ui/fluent_ui.dart';
import 'package:raptorx/src/features/brand_v2/brands/data/model/brand_model.dart';
import 'package:raptorx/src/features/source_mould/presentation/view/source_mould_screen.dart';

class BrandDetailsEditComponent extends StatefulWidget {
  const BrandDetailsEditComponent({super.key, required this.brandModel});
  final BrandModel brandModel;
  @override
  State<BrandDetailsEditComponent> createState() =>
      _BrandDetailsEditComponentState();
}

class _BrandDetailsEditComponentState extends State<BrandDetailsEditComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SourceMouldScreen(
            brandModel: widget.brandModel,
          ),
        )
      ],
    );
  }
}
