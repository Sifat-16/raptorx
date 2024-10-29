import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/features/brand/create_brand/presentation/view_model/create_brand_generic.dart';

final createBrandProvider =
    StateNotifierProvider<CreateBrandController, CreateBrandGeneric>(
        (ref) => CreateBrandController(ref));

class CreateBrandController extends StateNotifier<CreateBrandGeneric> {
  CreateBrandController(this.ref) : super(CreateBrandGeneric());

  Ref ref;

  updateSelected(int index) {
    state = state.update(selected: index);
  }
}
