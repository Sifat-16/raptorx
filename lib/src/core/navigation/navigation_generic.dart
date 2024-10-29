import 'package:fluent_ui/fluent_ui.dart';

class NavigatorGeneric{
  int topIndex;
  PaneDisplayMode displayMode;
  NavigatorGeneric({
    this.topIndex=0,
    this.displayMode = PaneDisplayMode.compact
});

  NavigatorGeneric update({
    int? topIndex,
    PaneDisplayMode? displayMode
}){

    return NavigatorGeneric(topIndex: topIndex??this.topIndex, displayMode: displayMode??this.displayMode);

  }
}