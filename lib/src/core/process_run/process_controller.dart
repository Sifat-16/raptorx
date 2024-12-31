import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pty/flutter_pty.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/core/build_config/build_controller.dart';
import 'package:raptorx/src/core/process_run/process_generic.dart';
import 'package:xterm/core.dart';
import 'package:xterm/ui.dart';

// Using a family provider to create multiple instances of ProcessController
final processProvider =
    StateNotifierProvider.family<ProcessController, ProcessGeneric, String>(
        (ref, id) {
  return ProcessController(ref, id);
});

class ProcessController extends StateNotifier<ProcessGeneric> {
  ProcessController(this.ref, this.id) : super(ProcessGeneric());

  final Ref ref;
  final String id; // Unique ID for this instance
  final terminal = Terminal(maxLines: 100000);
  final terminalController = TerminalController();
  final String startSignal = "start-signal-463374t473937384acasd";
  final String endSignal = "end-signal-463374t473937384acasd";

  late Pty _pty;
  Completer<void>? _completer;
  Function(String)? extractor;

  Future<void> runCommand(
      {required String command, Function(String)? dataExtractor}) async {
    try {
      if (state.isProcessing) {
        BotToast.showText(text: "A process is already running");
        return;
      }

      _completer = Completer<void>();

      if (dataExtractor != null) {
        extractor = dataExtractor;
      }

      _pty.write(const Utf8Encoder().convert(
          "echo $startSignal && $command || true && echo $endSignal\n"));

      await _completer!.future;

      // You can now execute additional logic after the command has completed
      _onProcessFinished();
    } catch (e) {
      print("Error: $e");
    }
  }

  void startPty({String? workingDirectory}) {
    _pty = Pty.start(
      _getShell(),
      columns: terminal.viewWidth,
      rows: terminal.viewHeight,
      workingDirectory: workingDirectory ??
          ref.read(buildConfigProvider).buildConfigModel?.sourceCodeDirectory,
    );

    _pty.output.cast<List<int>>().transform(const Utf8Decoder()).listen((data) {
      terminal.write(data);
      try {
        extractor!(data);
      } catch (e) {}
      if (data.contains(startSignal)) {
        state = state.update(isProcessing: true);
      } else if (data.contains(endSignal)) {
        state = state.update(isProcessing: false);
        extractor = null;
        _completer
            ?.complete(); // Completes the Future when the end signal is detected
      }
    }, onDone: () {
      print("Process finished");
    }, onError: (error) {
      terminal.write('Error: $error');
    });

    _pty.exitCode.then((code) {
      terminal.write('The process exited with exit code $code');
    });

    terminal.onOutput = (data) {
      _pty.write(const Utf8Encoder().convert(data));
    };

    terminal.onResize = (w, h, pw, ph) {
      _pty.resize(h, w);
    };
  }

  void _onProcessFinished() {
    terminal.write('The process has finished. Executing next steps...');
    // Additional logic can go here
  }

  String _getShell() {
    if (Platform.isMacOS || Platform.isLinux) {
      return Platform.environment['SHELL'] ?? 'bash';
    }
    if (Platform.isWindows) {
      return 'cmd.exe';
    }
    return 'sh';
  }

  void handleOutput(String data) {
    _pty.write(const Utf8Encoder().convert(data));
  }

  void handleResize(int w, int h, int pw, int ph) {
    _pty.resize(h, w);
  }

  void onSecondaryTapDown(details, offset) async {
    final selection = terminalController.selection;
    if (selection != null) {
      final text = terminal.buffer.getText(selection);
      terminalController.clearSelection();
      await Clipboard.setData(ClipboardData(text: text));
    } else {
      final data = await Clipboard.getData('text/plain');
      final text = data?.text;
      if (text != null) {
        terminal.paste(text);
      }
    }
  }
}
