import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeBodyItem extends ConsumerStatefulWidget {
  const HomeBodyItem({super.key});
  @override
  ConsumerState<HomeBodyItem> createState() => _BrandScreenState();
}

class _BrandScreenState extends ConsumerState<HomeBodyItem> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.withPadding(
      header: const Text("Home"),
      content: const SingleChildScrollView(),
    );
  }
}
