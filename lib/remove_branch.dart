import 'package:li/single_arg.dart';

class RemoveBranch extends SinglePositionalArgCommand {
  @override
  String get description => 'Remove a Git branch both locally and remotely.';

  @override
  String get name => 'remove_branch';

  @override
  String get argName => 'branch';

  @override
  void runWithSingleArg(String branch) {
    checkedRun('git', ['branch', '-d', branch]);
    checkedRun('git', ['push', 'origin', '--delete', branch]);
  }
}
