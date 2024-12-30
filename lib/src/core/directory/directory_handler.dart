import 'dart:io';

import 'package:bot_toast/bot_toast.dart';

class DirectoryHandler {
  static bool checkValidDirectory(
      {required String location, bool showToast = false}) {
    Directory directory = Directory(location);
    if (directory.existsSync()) {
      return true;
    }
    if (showToast) {
      BotToast.showText(text: "Directory doesn't exists");
    }

    return false;
  }
}
