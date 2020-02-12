import 'dart:io';

import 'package:test/test.dart';

void main() {
  test('Print expected errors.', () {
    final ProcessResult result = Process.runSync(
      'dart',
      <String>[
        'bin/li.dart',
        'remove_branch',
        'this-does-not-exist',
      ],
    );
    expect(result.stderr, contains(
'''
Exit code 1 != 0:

cmd: git

args: [branch, -d, this-does-not-exist]

stdout:
===============

===============

stderr:
===============
error: branch 'this-does-not-exist' not found.

===============
''',
    ));
  });
}
