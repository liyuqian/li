import 'dart:io';

import 'package:li/github/base.dart';
import 'package:test/test.dart';

void main() {
  test('Can run help without Github envrionment variable.', () {
    final env = Map<String, String>.from(Platform.environment);
    env.remove(GithubClientCommand.kTokenEnvName);
    final result = Process.runSync(
      'dart',
      ['bin/li.dart', '--help'],
      environment: env,
      includeParentEnvironment: false,
    );
    expect(result.exitCode, equals(0));
  });
}
