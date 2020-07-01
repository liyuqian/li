import 'dart:math' as math;
import 'package:stats/stats.dart';
import 'package:normal/normal.dart';

double sqr(a) => a * a;

int computeReps(int bisectLength, double confidence,
    List<double> samplesBeforeRegression, List<double> samplesAfterRegression) {
  if (bisectLength <= 1) {
    throw 'bisectLength must be greater than 1.';
  }
  final int maxBisectSteps = (math.log(bisectLength) * math.log2e).ceil();
  final double prError = 1 - math.pow(confidence, 1 / maxBisectSteps);
  print('prError = $prError (confidence = $confidence, max steps = $maxBisectSteps)');

  final statsBefore = Stats.fromData(samplesBeforeRegression);
  final statsAfter = Stats.fromData(samplesAfterRegression);

  print('statsBefore: $statsBefore');
  print('statsAfter: $statsAfter');

  final double gap = (statsAfter.average - statsBefore.average).abs();
  final double err = gap / 2;
  final double maxDeviation = math.max(statsBefore.standardDeviation, statsAfter.standardDeviation);

  return sqr(maxDeviation / err * Normal.quantile(prError / 2)).ceil();
}

void main() {
  final int reps = computeReps(
    2,
    0.9,
    <double>[28.661, 30.083, 28.517, 30.863, 27.902, 27.749],
    <double>[29.382, 30.693, 29.433, 29.274, 34.464, 28.624],
  );
  print('computeReps = $reps');
}
