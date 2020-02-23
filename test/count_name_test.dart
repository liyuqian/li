import 'dart:io';

import 'package:test/test.dart';

void main() {
  test('Count the expected number', () {
    final ProcessResult result = Process.runSync(
      'dart',
      <String>[
        'bin/li.dart',
        'count_name',
        'test/resources/test_names.txt',
      ],
    );
    expect(result.stdout, equals('''
7 unique names counted:
{garyq@, liyuqian@, jmccandless@, chinmaygarde@, jimgraham@, ychris@, zsunkun@github.com}
'''));
  });
}
