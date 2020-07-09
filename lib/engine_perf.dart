import 'dart:io';
import 'dart:math' as math;

import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';
import 'package:normal/normal.dart';
import 'package:stats/stats.dart';

class EnginePerf extends Command<void> {
  @override
  String get description => 'Check the Flutter engine performance using '
      'a devicelab perf test. This is usually used with `git bisect` to '
      'pinpoint an engine performance regression';

  @override
  String get name => 'engine_perf';

  EnginePerf() {
    argParser.addOption(
      _kTaskNameOption,
      abbr: 'n',
      help: 'the devicelab task name',
    );
    argParser.addOption(
      _kMetricNameOption,
      abbr: 'm',
      help: 'the metric name as a key in the resulted task json output',
    );
    argParser.addOption(
      _kThresholdOption,
      abbr: 't',
      help: 'the threshold of the metric to report a regression',
    );
    argParser.addOption(
      _kRepetitionsOption,
      abbr: 'r',
      help: 'the number of times to run the task and average the metric',
      defaultsTo: '1',
    );
    argParser.addFlag(
      _kSmallerIsBetterFlag,
      help: 'whether smaller metrics are better so being greater than the '
          'threshold is a regression',
      defaultsTo: true,
    );

    final bool canGuessPath = Platform.isLinux || Platform.isMacOS;
    argParser.addOption(
      _kFrameworkPathOption,
      abbr: 'f',
      help: 'the path to a local Flutter framework repo checkout',
      defaultsTo: canGuessPath
          ? Platform.environment['HOME'] + '/flutter/flutter/'
          : null,
    );
    argParser.addOption(
      _kEnginePathOption,
      abbr: 'e',
      help: 'the path to a local Flutter engine repo checkout',
      defaultsTo: canGuessPath
          ? Platform.environment['HOME'] + '/flutter/engine/src/flutter/'
          : null,
    );
    argParser.addFlag(
      _kIsAndroidFlag,
      help: 'whether this is an Android test or iOS test',
      defaultsTo: true,
    );
    argParser.addOption(
      _kOutFileOption,
      help: 'the file to write the stdout of subprocesses',
      defaultsTo: 'engine_perf.out',
    );
    argParser.addOption(
      _kErrFileOption,
      help: 'the file to write the stdout of subprocesses',
      defaultsTo: 'engine_perf.err',
    );
  }

  @override
  Future<void> run() async {
    _checkOptions();
    _outSink = File(argResults[_kOutFileOption]).openWrite();
    _errSink = File(argResults[_kErrFileOption]).openWrite();

    final pattern = RegExp('"${_metricName}": ' + r'(\d+\.?\d*)');

    await _compileEngine();
    Directory.current = _frameworkPath + '/dev/devicelab';
    final List<double> samples = [];
    for (int i = 0; i < _repetitions; i += 1) {
      print('Running $_taskName (${i + 1}/$_repetitions)');
      for (bool tested = false; !tested;) {
        int exitCode = await _runProcessThatMayFail(
          '../../bin/cache/dart-sdk/bin/dart',
          <String>[
            'bin/run.dart',
            '-t',
            _taskName,
            '--local-engine',
            '${_androidOrIos}_profile',
          ],
          separateOut: true,
        );
        tested = (exitCode == 0);
      }

      bool found = false;
      final lines = File(_kSeparateOutName).readAsLinesSync();
      for (final String line in lines) {
        if (pattern.hasMatch(line)) {
          final double metric = double.parse(pattern.firstMatch(line).group(1));
          samples.add(metric);
          print('Got ${_metricName}: $metric\n');
          found = true;
          break;
        }
      }

      if (!found) {
        throw 'Metric ${_metricName} not found in '
            '${Directory.current.path}/${_kSeparateOutName}';
      }
      File(_kSeparateOutName).deleteSync();
    }

    if (analyzeSamplesForRegression(samples,
        threshold: _threshold, smallerIsBetter: _smallerIsBetter)) {
      exit(1);
    }
  }

  /// Return whether the sample average crosses the threshold.
  static bool analyzeSamplesForRegression(
    List<double> samples, {
    @required double threshold,
    @required bool smallerIsBetter,
    StringSink out,
  }) {
    out ??= stdout;
    final stats = Stats.fromData(samples);
    final double average = stats.average;
    final averageDeviation = stats.standardDeviation / math.sqrt(stats.count);
    final double gap = (average - threshold).abs();
    out.writeln('n samples = ${stats.count}');
    out.writeln('gap = |average - threshold| = |$average - $threshold| = $gap');
    out.writeln('deviation = ${stats.standardDeviation}');
    out.writeln('average deviation = deviation / sqrt(n) = $averageDeviation');

    final double p =
        averageDeviation == 0 ? 1 : 2 * Normal.cdf(-gap / averageDeviation);
    out.writeln(
      'Pr(|average of ${stats.count} runs - true average| >= $gap) ~= $p',
    );

    bool hasRegression =
        smallerIsBetter ? average > threshold : average < threshold;
    final String verb = hasRegression ? 'crosses' : 'is within';
    out.writeln('Regression detected as the average $average $verb the '
        'threshold ${threshold} with confidence ${1 - p}.');

    return hasRegression;
  }

  void _checkOptions() {
    for (final String option in _requiredOptions) {
      if (argResults[option] == null) {
        throw 'Option $option must be set.';
      }
    }
  }

  Future<void> _compileEngine() async {
    print('Compiling engine...');
    Directory.current = _enginePath + '/../';
    await _runProcess(
      'gclient',
      <String>['sync', '-D'],
    );
    await _runProcess(
      'autoninja',
      <String>['-C', 'out/${_androidOrIos}_profile'],
    );
    await _runProcess(
      'autoninja',
      <String>['-C', 'out/host_profile'],
    );
    print('Engine compiled.\n');
  }

  Future<void> _runProcess(String executable, List<String> args,
      {bool separateOut = false}) async {
    final int exitCode = await _runProcessThatMayFail(executable, args,
        separateOut: separateOut);
    if (exitCode != 0) {
      throw 'Unexpected exit code $exitCode for $executable $args';
    }
  }

  Future<int> _runProcessThatMayFail(String executable, List<String> args,
      {bool separateOut = false}) async {
    _outSink.writeln('===Run $executable with $args===');
    final process = await Process.start(executable, args);
    final List<Future> streamFutures = [];
    streamFutures.add(_errSink.addStream(process.stderr));
    if (!separateOut) {
      streamFutures.add(_outSink.addStream(process.stdout));
    } else {
      final broadcastOut = process.stdout.asBroadcastStream();
      streamFutures.add(_outSink.addStream(broadcastOut));
      streamFutures
          .add(File(_kSeparateOutName).openWrite().addStream(broadcastOut));
    }
    await Future.wait(streamFutures);
    _outSink.writeln('===Run finished===\n');
    return await process.exitCode;
  }

  String get _taskName => argResults[_kTaskNameOption];
  String get _metricName => argResults[_kMetricNameOption];
  int get _repetitions => int.parse(argResults[_kRepetitionsOption]);
  String get _frameworkPath => argResults[_kFrameworkPathOption];
  String get _enginePath => argResults[_kEnginePathOption];
  String get _androidOrIos => argResults[_kIsAndroidFlag] ? 'android' : 'ios';
  bool get _smallerIsBetter => argResults[_kSmallerIsBetterFlag];
  double get _threshold => double.parse(argResults[_kThresholdOption]);

  IOSink _outSink;
  IOSink _errSink;

  static const String _kTaskNameOption = 'task-name';
  static const String _kMetricNameOption = 'metric-name';
  static const String _kThresholdOption = 'threshold';
  static const String _kRepetitionsOption = 'repetitions';
  static const String _kSmallerIsBetterFlag = 'smaller-is-better';
  static const String _kFrameworkPathOption = 'framework-path';
  static const String _kEnginePathOption = 'engine-path';
  static const String _kIsAndroidFlag = 'is-android';
  static const String _kOutFileOption = 'out-file';
  static const String _kErrFileOption = 'err-file';

  static const String _kSeparateOutName = 'separate.out';

  static const List<String> _requiredOptions = <String>[
    _kTaskNameOption,
    _kMetricNameOption,
    _kThresholdOption,
    _kFrameworkPathOption,
    _kEnginePathOption,
  ];
}
