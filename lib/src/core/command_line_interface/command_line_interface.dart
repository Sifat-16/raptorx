import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/core/process_run/process_controller.dart';
import 'package:xterm/ui.dart';

class CommandLineInterface extends ConsumerStatefulWidget {
  const CommandLineInterface({super.key, required this.pid});
  final String pid;

  @override
  _CommandLineInterfaceState createState() => _CommandLineInterfaceState();
}

class _CommandLineInterfaceState extends ConsumerState<CommandLineInterface> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then(
      (_) {
        if (mounted) ref.read(processProvider(widget.pid).notifier).startPty();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final process = ref.watch(processProvider(widget.pid));

    return SizedBox(
      height: MediaQuery.of(context).size.height * .3,
      width: MediaQuery.of(context).size.width * .3,
      child: Column(
        children: [
          Icon(process.isProcessing ? Icons.stop_circle : Icons.play_circle),
          Expanded(
            child: TerminalView(
              ref.read(processProvider(widget.pid).notifier).terminal,
              controller: ref
                  .read(processProvider(widget.pid).notifier)
                  .terminalController,
              autofocus: true,
              backgroundOpacity: 0.7,
              onSecondaryTapDown: ref
                  .read(processProvider(widget.pid).notifier)
                  .onSecondaryTapDown,
            ),
          ),
        ],
      ),
    );
  }
}

String get shell {
  if (Platform.isMacOS || Platform.isLinux) {
    return Platform.environment['SHELL'] ?? 'bash';
  }

  if (Platform.isWindows) {
    return 'cmd.exe';
  }

  return 'sh';
}
