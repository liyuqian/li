import 'dart:io';

import 'package:path/path.dart' as path;

import 'package:test/test.dart';

void main() {
  test('Catch flaky 4th run', () {
    final Directory tempDir = Directory.systemTemp.createTempSync();
    final String filePath = path.join(tempDir.path, 'test.txt');
    File(filePath).writeAsStringSync('1');
    final result = Process.runSync(
      'dart',
      <String>[
        'bin/li.dart',
        'deflake',
        '--',
        'dart',
        'test/resources/fail_at_x_every_y_runs_exit_z.dart',
        filePath,
        '4',
        '5',
        '-1',
      ],
    );
    expect(result.exitCode, 1);
    expect(
      result.stdout.toString(),
      contains(
        'Found flake with 1 failures > 5 * 0.0'
        ' = 0.0 allowed failures after 4-th try.',
      ),
    );
  });

  test('Pass 1-in-10 failure with 0.2 ratio', () {
    final Directory tempDir = Directory.systemTemp.createTempSync();
    final String filePath = path.join(tempDir.path, 'test.txt');
    File(filePath).writeAsStringSync('1');
    final result = Process.runSync(
      'dart',
      <String>[
        'bin/li.dart',
        'deflake',
        '-r', '0.2',
        '--',
        'dart',
        'test/resources/fail_at_x_every_y_runs_exit_z.dart',
        filePath,
        '3',
        '5',
        '-1',
      ],
    );
    expect(result.exitCode, 0);
  });

  test('Fail 1-in-5 failure with 0.1 ratio', () {
    final Directory tempDir = Directory.systemTemp.createTempSync();
    final String filePath = path.join(tempDir.path, 'test.txt');
    File(filePath).writeAsStringSync('1');
    final result = Process.runSync(
      'dart',
      <String>[
        'bin/li.dart',
        'deflake',
        '-r', '0.1',
        '-t', '10',
        '--',
        'dart',
        'test/resources/fail_at_x_every_y_runs_exit_z.dart',
        filePath,
        '3',
        '5',
        '-1',
      ],
    );
    expect(result.exitCode, 1);
    expect(
      result.stdout.toString(),
      contains(
        'Found flake with 2 failures > 10 * 0.1'
        ' = 1.0 allowed failures after 8-th try.',
      ),
    );
  });

  test('Can ignore exit code 247 (-9)', () {
    final Directory tempDir = Directory.systemTemp.createTempSync();
    final String filePath = path.join(tempDir.path, 'test.txt');
    File(filePath).writeAsStringSync('1');
    final result = Process.runSync(
      'dart',
      <String>[
        'bin/li.dart',
        'deflake',
        '-t', '10',
        '--ignore', '247',
        '--',
        'dart',
        'test/resources/fail_at_x_every_y_runs_exit_z.dart',
        filePath,
        '3',
        '5',
        '-9',
      ],
    );
    expect(result.exitCode, 0);

    // We should have 2 copies of "Try 3:" because the first one is ignored.
    expect(RegExp('Try 3:').allMatches(result.stdout.toString()).length, 2);
  });

  test('Default to run 5 times', () {
    final result = Process.runSync(
      'dart',
      <String>[
        'bin/li.dart',
        'deflake',
        'echo',
        'hello',
      ],
    );
    expect(result.exitCode, 0);

    final String stdoutString = result.stdout.toString();
    expect(stdoutString, contains('Try 5:'));
    expect(stdoutString, isNot(contains('Try 6:')));
  });

  test('Can set to run 10 times', () {
    final result = Process.runSync(
      'dart',
      <String>[
        'bin/li.dart',
        'deflake',
        'echo',
        'hello',
        '-t', '10',
      ],
    );
    expect(result.exitCode, 0);

    final String stdoutString = result.stdout.toString();
    expect(stdoutString, contains('Try 10:'));
    expect(stdoutString, isNot(contains('Try 11:')));
  });

  test('Can set bypass -t', () {
    final result = Process.runSync(
      'dart',
      <String>[
        'bin/li.dart',
        'deflake',
        '--',
        'echo',
        'hello',
        '-t',
        '10',
      ],
    );
    expect(result.exitCode, 0);

    final String stdoutString = result.stdout.toString();
    expect(stdoutString, contains('hello -t 10'));
    expect(stdoutString, contains('Try 5:'));
    expect(stdoutString, isNot(contains('Try 6:')));
  });
}
