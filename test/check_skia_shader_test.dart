import 'dart:io';

import 'package:test/test.dart';

const String _kExpectedDirOutput = '''
Found 2 shaders in SkSL type.
  test/resources/shader_cache/CAZAAAACAAAAAAAAAAAACAAAAAJQAAIADQABIAAPAALQAAAAAAABIAA2AAAAAAAAAAAAAAACAAAAAKAAMMAA
  test/resources/shader_cache/CAZAAAACAAAAAAAAAAABGAABAAOAAFAADQAAGAAQABSQAAAAAAAAAAAAAABAAAAAEAAGGAA

Found 1 shaders in binary type.
  test/resources/shader_cache/CAZAAAACAAAAACIAAAABGAABAAOAAAYABQAEMAAAAAAAAAAAAAAAEAAAAAOAAYYA

Found 0 shaders in unknown type.

''';

void main() {
  final String shaderDirectoryPath = 'test/resources/shader_cache/';
  final String skslFilePath = shaderDirectoryPath +
      'CAZAAAACAAAAAAAAAAAACAAAAAJQAAIADQABIAAPAALQAAAAAAAB'
      'IAA2AAAAAAAAAAAAAAACAAAAAKAAMMAA';
  final String binaryFilePath = shaderDirectoryPath +
      'CAZAAAACAAAAACIAAAABGAABAAOAAAYABQAEMAAAAAAAAAAAAAAAEAAAAAOAAYYA';

  test('Can detect SkSL', () {
    final ProcessResult result = Process.runSync(
      'dart',
      <String>[
        'bin/li.dart',
        'check_skia_shader',
        skslFilePath,
      ],
    );
    expect(result.stdout, equals('SkSL type\n'));
  });

  test('Can detect binary', () {
    final ProcessResult result = Process.runSync(
      'dart',
      <String>[
        'bin/li.dart',
        'check_skia_shader',
        binaryFilePath,
      ],
    );
    expect(result.stdout, equals('binary type\n'));
  });

  test('Can detect directory', () {
    final ProcessResult result = Process.runSync(
      'dart',
      <String>[
        'bin/li.dart',
        'check_skia_shader',
        shaderDirectoryPath,
      ],
    );
    expect(result.stdout, equals(_kExpectedDirOutput));
  });
}
