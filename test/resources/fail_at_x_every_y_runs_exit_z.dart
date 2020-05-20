import 'dart:io';

void main(List<String> args) {
  final String filename = args[0];
  final int x = int.parse(args[1]);
  final int y = int.parse(args[2]);
  final int z = int.parse(args[3]);

  // File `filename` should be initialized to 1 so this will fail at x-th run
  // every y runs.
  final int i = int.parse(File(filename).readAsStringSync());
  File(filename).writeAsStringSync('${i + 1}');
  if ((i - 1) % y == x - 1) {
    print('Fail at $i! (x = $x, y = $y)');
    exit(z);
  }
}
