import 'dart:io';

import 'package:li/single_arg.dart';

class CountName extends SinglePositionalArgCommand {
  @override
  String get description => 'Count the number of unique names in a text file. '
      'The name is supposed to be in the format of name@[domain].';

  @override
  String get argName => 'filename';

  @override
  String get name => 'count_name';

  @override
  void runWithSingleArg(String arg) {
    final String input = File(arg).readAsStringSync();
    final List<String> words = input.split(RegExp(r'(\n| |,)'));
    final Set<String> names = words.where((String w) => w.contains('@')).toSet();
    print('${names.length} unique names counted:\n$names');
  }
}
