import 'dart:io';

import 'package:args/command_runner.dart';

class Deflake extends Command<void> {
  Deflake() {
    argParser.addOption(
      _kTimesOption,
      abbr: 't',
      defaultsTo: '5',
      help: 'The number of times to try a command to see if it is flaky.',
    );
    argParser.addOption(
      _kRatioOption,
      abbr: 'r',
      defaultsTo: '0',
      help: 'The ratio of failure allowed.',
    );
    argParser.addOption(_kIgnoreOption,
        help:
            'The exit code to ignore: if a the command returns this exit code, '
            'we will not count it as a failure or success and just retry. For '
            'example, we may want to ignore -9 (254) which seems to be the OOM '
            'error returned by Dart.');
  }

  @override
  String get description => 'Run a command multiple times and report '
      'failure (being flaky) if a large ratio fails.';

  @override
  String get name => 'deflake';

  @override
  Future<void> run() async {
    if (argResults.rest.isEmpty) {
      throw 'No command is given to try.';
    }
    final int times = int.parse(argResults[_kTimesOption]);
    final double ratio = double.parse(argResults[_kRatioOption]);
    final int ignore = argResults[_kIgnoreOption] == null
        ? null
        : int.parse(argResults[_kIgnoreOption]);

    int failCount = 0;
    int ignoreCount = 0;
    for (int i = 1; i <= times; i += 1) {
      print('Try $i:');
      final Process process =
          await Process.start(argResults.rest[0], argResults.rest.sublist(1));
      final Future stdoutDone = stdout.addStream(process.stdout);
      final Future stderrDone = stderr.addStream(process.stderr);
      await stdoutDone;
      await stderrDone;
      final int exitCode = await process.exitCode;
      print('');

      if (exitCode != 0) {
        if (exitCode == ignore) {
          i -= 1;
          ignoreCount += 1;
          if (ignoreCount > 100) {
            throw 'We are likely in a dead loop...';
          }
          continue;
        }

        failCount += 1;
        print('Failed $i-th try with exit code $exitCode.');

        if (failCount > times * ratio) {
          print(
            'Found flake with $failCount failures > $times * $ratio'
            ' = ${times * ratio} allowed failures after $i-th try.',
          );

          // `git bisect run` needs the exit code to be within [0, 128) so we'll
          // exit with 1 instead of the original exitCode (which could be -1).
          exit(1);
        }
      }
    }
  }

  static const String _kTimesOption = 'times';
  static const String _kRatioOption = 'ratio';
  static const String _kIgnoreOption = 'ignore';
}
