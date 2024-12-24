import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'navigation_generic.dart';

final navigationProvider =
    StateNotifierProvider<NavigationController, NavigatorGeneric>(
        (ref) => NavigationController(ref));

class NavigationController extends StateNotifier<NavigatorGeneric> {
  NavigationController(this.ref) : super(NavigatorGeneric());
  Ref ref;

  updateTopIndex(int index) {
    state = state.update(topIndex: index);
  }

  updateDisplayMode(PaneDisplayMode displayMode) {
    state = state.update(displayMode: displayMode);
  }
}
