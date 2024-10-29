import 'package:xterm/core.dart';
import 'package:xterm/xterm.dart';

class ProcessGeneric{


  bool isProcessing;
  ProcessGeneric({this.isProcessing=false});

  ProcessGeneric update({bool? isProcessing}){
    return ProcessGeneric(isProcessing: isProcessing??this.isProcessing);
  }

}