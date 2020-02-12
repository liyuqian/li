import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';

abstract class SinglePositionalArgCommand extends Command<void> {
  String get argName;

  @override
  String get usage {
    return super.usage.split('\n').map((String line) {
      return line + (line.startsWith('Usage:') ? ' <$argName>' : '');
    }).join('\n');
  }

  @protected
  void checkArgCount() {
    if (argResults.rest.length != 1) {
      print(usage);
      throw Exception(
        'Exactly 1 argument <$argName> expected, '
        '${argResults.rest.length} provided.',
      );
    }
  }

  @protected
  void checkedRun(String cmd, List<String> args) {
    ProcessResult result = Process.runSync(cmd, args);
    if (result.exitCode != 0) {
      final String info =
'''
cmd: $cmd

args: $args

stdout:
===============
${result.stdout}
===============

stderr:
===============
${result.stderr}
===============
''';
      throw 'Exit code ${result.exitCode} != 0:\n\n$info';
    }
  }
}
