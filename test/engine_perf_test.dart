import 'dart:io';

import 'package:li/engine_perf.dart';
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

  test('analyzeSamplesForRegression prints correct numbers', () {
    final testOut = StringBuffer();
    final samples = <double>[
      33.981,
      34.243,
      26.003,
      33.645,
      33.416,
      35.3,
      27.817,
      28.379,
      27.16,
      28.581,
      27.63,
      34.783,
      29.575,
      28.682,
      33.78,
      28.625,
      34.922,
      28.8,
      27.873,
      28.142,
      34.95,
      27.875,
      34.068,
    ];
    bool regressed = EnginePerf.analyzeSamplesForRegression(samples,
        threshold: 29.637, smallerIsBetter: true, out: testOut);
    expect(regressed, true);

    final expectedOut = '''
n samples = 23
gap = |average - threshold| = |30.792608695652174 - 29.637| = 1.1556086956521732
deviation = 3.1739114770692978
average deviation = deviation / sqrt(n) = 0.6618062919101294
Pr(|average of 23 runs - true average| >= 1.1556086956521732) ~= 0.08078595026902005
Regression detected as the average 30.792608695652174 crosses the threshold 29.637 with confidence 0.91921404973098.
''';
    expect(testOut.toString(), expectedOut);
  });
}
