import 'dart:io';

import 'package:test/test.dart';

void main() {
  test('Task name is required', () async {
    final result = Process.runSync(
      'dart',
      <String>[
        'bin/li.dart',
        'engine_perf',
      ],
    );
    expect(result.exitCode, isNot(0));
    expect(result.stderr.toString(), contains('Option task-name must be set.'));
  });
}
