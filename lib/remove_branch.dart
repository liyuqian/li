import 'package:li/single_arg.dart';

class RemoveBranch extends SinglePositionalArgCommand {
  @override
  String get description => 'Remove a Git branch both locally and remotely.';

  @override
  String get name => 'remove_branch';

  @override
  String get argName => 'branch';

  @override
  Future<void> run() async {
    checkArgCount();
    final String branch = argResults.rest[0];
    checkedRun('git', ['branch', '-d', branch]);
    checkedRun('git', ['push', 'origin', '--delete', branch]);
  }
}
